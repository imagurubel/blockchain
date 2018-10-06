pragma solidity ^0.4.19;

contract Panda {

	uint constant statusCreated = 1;
	uint constant statusConfirmed = 2;
	uint constant statusResultSubmitted = 3;
	uint constant statusCompletedSuccessfully = 4;
	uint constant statusCompletedUnsuccessfully = 5;
	uint constant statusReviewStarted = 6;
	uint constant statusReviewSubmited = 7;
	uint constant statusArbitrageRequested = 8;
	uint constant statusArbitrageCompleted = 9;
	uint constant statusCanceledBeforeConfirmed = 10;
	uint constant verdictGood = 1;
	uint constant verdictBaad = 2;
	uint minServiceFee = 10000000000000000; // 0.01 ETH
	uint minPerformerRatingWithoutReview = 8;

	uint public lastTaskId;

	struct Task {
		uint status;
		address creator;
		address performer;
		address reviewer;
		bytes32 taskHash;
		bytes32 resultHash;
		uint creatorRatingByPerformer;
		uint creatorRatingByReviewer;
		uint performerRating;
		uint reviewerRating;
		uint creatorPays;
		uint performerPays;
		uint reviewerVerdict;
		uint arbitrageVerdict;
	}

	struct TaskTiming {
		uint duration;
		uint createdAt;
		uint confirmedAt;
		uint resultSubmittedAt;
		uint completedAt;
		uint reviewStartedAt;
		uint reviewSubmittedAt;
		uint arbitrageSubmittedAt;
	}

	mapping (uint256 => Task) public tasks;
	mapping (uint256 => TaskTiming) public tasksTiming;




	function taskCreate(bytes32 _taskHash, address _performer, uint _duration) public payable returns (uint256) {
		require(msg.value > minServiceFee);

		lastTaskId = lastTaskId + 1;
		tasks[lastTaskId].status = statusCreated;
		tasks[lastTaskId].creator = msg.sender;
		tasks[lastTaskId].taskHash = _taskHash;
		tasks[lastTaskId].performer = _performer;
		tasks[lastTaskId].creatorPays = msg.value;
		tasks[lastTaskId].performerPays = msg.value * 20 / 100;
		tasksTiming[lastTaskId].createdAt = block.timestamp;
		tasksTiming[lastTaskId].duration =  _duration;

		return lastTaskId;
	}


	function taskCancelBeforeConfirmed(uint _taskId) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusCreated);

		tasks[_taskId].status = statusCanceledBeforeConfirmed;
		tasksTiming[_taskId].completedAt = block.timestamp;
		tasks[_taskId].creator.transfer(tasks[_taskId].creatorPays);
	}


	function taskConfirm(uint _taskId) public payable {
		require(tasks[_taskId].performer == msg.sender);
		require(tasks[_taskId].status == statusCreated);
		require(tasks[lastTaskId].performerPays == msg.value);

		tasks[_taskId].status = statusConfirmed;
		tasksTiming[lastTaskId].confirmedAt = block.timestamp;
	}


	function taskCompleteUnsuccessfullyWithoutResultSubmittedAfterTimeout(uint _taskId, uint _performerRating) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusConfirmed);
		require(block.timestamp > tasksTiming[_taskId].createdAt + tasksTiming[_taskId].duration);
		require(_performerRating <= 10);

		tasks[_taskId].performerRating = _performerRating;
		tasks[_taskId].status = statusCompletedUnsuccessfully;
		tasksTiming[_taskId].completedAt = block.timestamp;
		tasks[_taskId].creator.transfer(tasks[_taskId].creatorPays);
		tasks[_taskId].performer.transfer(tasks[_taskId].performerPays);
	}


	function taskSubmitResult(uint _taskId, bytes32 _resultHash) public {
		require(tasks[_taskId].performer == msg.sender);
		require(tasks[_taskId].status == statusConfirmed);

		tasks[_taskId].status = statusResultSubmitted;
		tasks[_taskId].resultHash = _resultHash;
		tasksTiming[lastTaskId].resultSubmittedAt = block.timestamp;
	}


	function taskCompleteSuccessfullyWithoutReview(uint _taskId, uint _performerRating) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusResultSubmitted);
		require(_performerRating >= minPerformerRatingWithoutReview);
		require(_performerRating <= 10);

		tasks[_taskId].status = statusCompletedSuccessfully;
		tasksTiming[_taskId].completedAt = block.timestamp;
		tasks[_taskId].performerRating = _performerRating;
		uint peroformerFee = calculatePeroformerFee(tasks[_taskId].creatorPays, tasks[_taskId].performerPays, 0);
		tasks[_taskId].performer.transfer(peroformerFee);
		tasks[_taskId].creator.transfer(calculateCreatorMoneyback(tasks[_taskId].creatorPays, peroformerFee, 0));
	}


	function taskCompleteSuccessfullyByPerformerAfterTimeout(uint _taskId) public {
		require(tasks[_taskId].performer == msg.sender);
		require(
			(tasks[_taskId].status == statusResultSubmitted && block.timestamp > tasksTiming[_taskId].resultSubmittedAt + 90 days)
			|| (tasks[_taskId].status == statusReviewStarted && block.timestamp > tasksTiming[_taskId].reviewStartedAt + 90 days)
			);

		tasks[_taskId].status = statusCompletedSuccessfully;
		tasksTiming[_taskId].completedAt = block.timestamp;
		uint peroformerFee = calculatePeroformerFee(tasks[_taskId].creatorPays, tasks[_taskId].performerPays, 0);
		tasks[_taskId].performer.transfer(peroformerFee);
		tasks[_taskId].creator.transfer(calculateCreatorMoneyback(tasks[_taskId].creatorPays, peroformerFee, 0));
	}


	function taskReviewStart(uint _taskId, address _reviewer) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusResultSubmitted
			|| (tasks[_taskId].status == statusReviewStarted && block.timestamp > tasksTiming[_taskId].reviewStartedAt + 7 days));

		tasks[_taskId].status = statusReviewStarted;
		tasks[_taskId].reviewer = _reviewer;
		tasksTiming[_taskId].reviewStartedAt = block.timestamp;
	}


	function taskReviewSubmit(uint _taskId, uint _reviewerVerdict, uint _performerRating) public {
		require(tasks[_taskId].reviewer == msg.sender);
		require(tasks[_taskId].status == statusReviewStarted);
		require(_reviewerVerdict == verdictGood || _reviewerVerdict == verdictBaad);
		require(_performerRating <= 10);

		tasks[_taskId].reviewerVerdict = _reviewerVerdict;
		tasks[_taskId].status = statusReviewSubmited;
		tasksTiming[_taskId].reviewSubmittedAt = block.timestamp;
		tasks[_taskId].performerRating = _performerRating;
	}


	function taskCompleteSuccessfullyAfterReview(uint _taskId, uint _reviewerRating) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusReviewSubmited);
		require(_reviewerRating <= 10);

		tasks[_taskId].status = statusCompletedSuccessfully;
		tasksTiming[_taskId].completedAt = block.timestamp;
		tasks[_taskId].reviewerRating = _reviewerRating;
		uint reviewerFee = calculateReviewerFee(tasks[_taskId].creatorPays);
		tasks[_taskId].reviewer.transfer(reviewerFee);
		uint peroformerFee = calculatePeroformerFee(tasks[_taskId].creatorPays, tasks[_taskId].performerPays, reviewerFee);
		tasks[_taskId].performer.transfer(peroformerFee);
	}


	function taskCompleteSuccessfullyAfterReviewByPerformerAfterTimeout(uint _taskId) public {
		require(tasks[_taskId].performer == msg.sender);
		require(tasks[_taskId].status == statusReviewSubmited);
		require(block.timestamp > tasksTiming[_taskId].reviewSubmittedAt + 7 days);

		tasks[_taskId].status = statusCompletedSuccessfully;
		tasksTiming[_taskId].completedAt = block.timestamp;
		uint reviewerFee = calculateReviewerFee(tasks[_taskId].creatorPays);
		tasks[_taskId].reviewer.transfer(reviewerFee);
		uint peroformerFee = calculatePeroformerFee(tasks[_taskId].creatorPays, tasks[_taskId].performerPays, reviewerFee);
		tasks[_taskId].performer.transfer(peroformerFee);
	}


	function taskCompleteUnsuccessfullyAfterReviewWithoutArbitrageAfterTimeout(uint _taskId, uint _reviewerRating) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusReviewSubmited);
		require(tasks[_taskId].reviewerVerdict == verdictBaad);
		require(block.timestamp > tasksTiming[_taskId].reviewSubmittedAt + 7 days);
		require(_reviewerRating <= 10);

		tasks[_taskId].status = statusCompletedUnsuccessfully;
		tasksTiming[_taskId].completedAt = block.timestamp;
		tasks[_taskId].reviewerRating = _reviewerRating;
		uint reviewerFee = calculateReviewerFee(tasks[_taskId].creatorPays);
		tasks[_taskId].reviewer.transfer(reviewerFee);
		tasks[_taskId].creator.transfer(calculateCreatorMoneyback(tasks[_taskId].creatorPays, 0, reviewerFee));
	}


	function taskRequestArbitrage(uint _taskId) public {
		require(tasks[_taskId].creator == msg.sender || tasks[_taskId].performer == msg.sender);
		require(tasks[_taskId].status == statusReviewSubmited);

		tasks[_taskId].status = statusArbitrageRequested;
	}


	function taskArbitrageVerdict(uint _taskId, uint _arbitrageVerdict) public {
		require(contractOwner == msg.sender);
		require(_arbitrageVerdict == verdictGood || _arbitrageVerdict == verdictBaad);
		require(tasks[_taskId].status == statusArbitrageRequested);

		tasks[_taskId].status = statusArbitrageCompleted;
		tasks[_taskId].arbitrageVerdict = _arbitrageVerdict;
		tasksTiming[_taskId].arbitrageSubmittedAt = block.timestamp;
	}


	function taskCompleteUnsuccessfullyAfterArbitrage(uint _taskId, uint _reviewerRating) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusArbitrageCompleted);
		require(tasks[_taskId].arbitrageVerdict == verdictBaad);
		require(_reviewerRating <= 10);

		tasks[_taskId].status = statusCompletedUnsuccessfully;
		tasksTiming[_taskId].completedAt = block.timestamp;
		tasks[_taskId].reviewerRating = _reviewerRating;
		uint reviewerFee = calculateReviewerFee(tasks[_taskId].creatorPays);
		tasks[_taskId].reviewer.transfer(reviewerFee);
		tasks[_taskId].creator.transfer(calculateCreatorMoneyback(tasks[_taskId].creatorPays, 0, reviewerFee));
	}


	function taskCompleteSuccessfullyAfterArbitrageByCreator(uint _taskId, uint _reviewerRating) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusArbitrageCompleted);
		require(tasks[_taskId].arbitrageVerdict == verdictGood);
		require(_reviewerRating <= 10);

		tasks[_taskId].status = statusCompletedSuccessfully;
		tasksTiming[_taskId].completedAt = block.timestamp;
		tasks[_taskId].reviewerRating = _reviewerRating;
		uint reviewerFee = calculateReviewerFee(tasks[_taskId].creatorPays);
		tasks[_taskId].reviewer.transfer(reviewerFee);
		uint peroformerFee = calculatePeroformerFee(tasks[_taskId].creatorPays, tasks[_taskId].performerPays, reviewerFee);
		tasks[_taskId].performer.transfer(peroformerFee);
	}


	function taskCompleteSuccessfullyAfterArbitrageByPerformerAfterTimeout(uint _taskId) public {
		require(tasks[_taskId].performer == msg.sender);
		require(tasks[_taskId].status == statusArbitrageCompleted);
		require(tasks[_taskId].arbitrageVerdict == verdictGood);
		require(block.timestamp > tasksTiming[_taskId].arbitrageSubmittedAt + 7 days);

		tasks[_taskId].status = statusCompletedSuccessfully;
		tasksTiming[_taskId].completedAt = block.timestamp;
		uint reviewerFee = calculateReviewerFee(tasks[_taskId].creatorPays);
		tasks[_taskId].reviewer.transfer(reviewerFee);
		uint peroformerFee = calculatePeroformerFee(tasks[_taskId].creatorPays, tasks[_taskId].performerPays, reviewerFee);
		tasks[_taskId].performer.transfer(peroformerFee);
	}


	function taskRateCreatorByPerformer(uint _taskId, uint _creatorRatingByPerformer) public {
		require(tasks[_taskId].performer == msg.sender);
		require(tasks[_taskId].status == statusCompletedSuccessfully || tasks[_taskId].status == statusCompletedUnsuccessfully);
		require(_creatorRatingByPerformer <= 10);
		require(tasks[_taskId].creatorRatingByPerformer == 0);

		tasks[_taskId].creatorRatingByPerformer = _creatorRatingByPerformer;
	}


	function taskRateCreatorByReviewer(uint _taskId, uint _creatorRatingByReviewer) public {
		require(tasks[_taskId].reviewer == msg.sender);
		require(tasks[_taskId].status == statusCompletedSuccessfully || tasks[_taskId].status == statusCompletedUnsuccessfully);
		require(_creatorRatingByReviewer <= 10);
		require(tasks[_taskId].creatorRatingByReviewer == 0);

		tasks[_taskId].creatorRatingByReviewer = _creatorRatingByReviewer;
	}

	function calculateReviewerFee(uint _creatorPays) pure public returns (uint256) {
		return _creatorPays * 20 / 100;
	}

	function calculatePeroformerFee(uint _creatorPays, uint _performerPays, uint _reviewerFee) view public returns (uint256) {
		return _creatorPays - _reviewerFee  + _performerPays - minServiceFee;
	}

	function calculateCreatorMoneyback(uint _creatorPays, uint _performerFee, uint _reviewerFee) view public returns (uint256) {
		return _creatorPays - _reviewerFee - _performerFee - minServiceFee;
	}


	constructor() public {
		contractOwner = msg.sender;
	}

	address public contractOwner;

}
