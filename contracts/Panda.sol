pragma solidity ^0.4.19;

contract Panda {

	uint constant statusCreated = 1;
	uint constant statusConfirmed = 2;
	uint constant statusResultSubmitted = 3;
	uint constant statusCompleted = 4;
	uint constant statusReviewStarted = 5;
	uint constant statusReviewSubmited = 6;
	uint constant reviewerVerdictGood = 1;
	uint constant reviewerVerdictBaad = 2;
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
		uint creatorRating;
		uint performerRating;
		uint revieverRating;
		uint creatorPays;
		uint performerPays;
		uint reviewerVerdict;
	}

	struct TaskTiming {
		uint createdAt;
		uint confirmedAt;
		uint resultSubmittedAt;
		uint completedAt;
		uint reviewStartedAt;
		uint reviewSubmittedAt;
	}

	mapping (uint256 => Task) public tasks;
	mapping (uint256 => TaskTiming) public tasksTiming;




	function taskCreate(bytes32 _taskHash, address _performer) public payable returns (uint256) {
		require(msg.value > minServiceFee);

		lastTaskId = lastTaskId + 1;
		tasks[lastTaskId].status = statusCreated;
		tasks[lastTaskId].creator = msg.sender;
		tasks[lastTaskId].taskHash = _taskHash;
		tasks[lastTaskId].performer = _performer;
		tasks[lastTaskId].creatorPays = msg.value;
		tasks[lastTaskId].performerPays = msg.value * 20 / 100;
		tasksTiming[lastTaskId].createdAt = block.timestamp;

		return lastTaskId;
	}


	function taskConfirm(uint _taskId) public payable {
		require(tasks[_taskId].performer == msg.sender);
		require(tasks[_taskId].status == statusCreated);
		require(tasks[lastTaskId].performerPays == msg.value);

		tasks[_taskId].status = statusConfirmed;
		tasksTiming[lastTaskId].confirmedAt = block.timestamp;
	}


	function taskSubmitResult(uint _taskId, bytes32 _resultHash) public {
		require(tasks[_taskId].performer == msg.sender);
		require(tasks[_taskId].status == statusConfirmed
			|| tasks[_taskId].status == statusResultSubmitted);

		tasks[_taskId].status = statusResultSubmitted;
		tasks[_taskId].resultHash = _resultHash;
		tasksTiming[lastTaskId].resultSubmittedAt = block.timestamp;
	}


	function taskCompleteSuccessfullyWithoutReview(uint _taskId, uint _performerRating) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusResultSubmitted);
		require(_performerRating >= minPerformerRatingWithoutReview);
		require(_performerRating <= 10);

		tasks[_taskId].status = statusCompleted;
		tasksTiming[_taskId].completedAt = block.timestamp;
		tasks[_taskId].performerRating = _performerRating;
		uint peroformerFee = calculatePeroformerFee(tasks[_taskId].creatorPays, tasks[_taskId].performerPays, 0);
		tasks[_taskId].performer.transfer(peroformerFee);
		tasks[_taskId].creator.transfer(calculateCreatorMoneyback(tasks[_taskId].creatorPays, peroformerFee, 0));
	}


	function taskReviewStart(uint _taskId, address _reviewer) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusResultSubmitted);

		tasks[_taskId].status = statusReviewStarted;
		tasks[_taskId].reviewer = _reviewer;
		tasksTiming[_taskId].reviewStartedAt = block.timestamp;
	}


	function taskReviewSubmit(uint _taskId, uint _reviewerVerdict, uint _performerRating) public {
		require(tasks[_taskId].reviewer == msg.sender);
		require(tasks[_taskId].status == statusReviewStarted);
		require(_reviewerVerdict == reviewerVerdictGood || _reviewerVerdict == reviewerVerdictBaad);

		tasks[_taskId].reviewerVerdict = _reviewerVerdict;
		tasks[_taskId].status = statusReviewSubmited;
		tasksTiming[_taskId].reviewSubmittedAt = block.timestamp;
		tasks[_taskId].performerRating = _performerRating;
	}


	function taskCompleteSuccessfullyAfterReview(uint _taskId, uint _revieverRating) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusReviewSubmited);

		tasks[_taskId].status = statusCompleted;
		tasksTiming[_taskId].completedAt = block.timestamp;
		tasks[_taskId].revieverRating = _revieverRating;
		uint reviewerFee = calculateReviewerFee(tasks[_taskId].creatorPays);
		tasks[_taskId].reviewer.transfer(reviewerFee);
		uint peroformerFee = calculatePeroformerFee(tasks[_taskId].creatorPays, tasks[_taskId].performerPays, reviewerFee);
		tasks[_taskId].performer.transfer(peroformerFee);
	}


	// TODO taskComplete with moneyback with performer agreement or service approval


	function taskRateCreator(uint _taskId, uint _creatorRating) public {
		require(tasks[_taskId].performer == msg.sender);
		require(tasks[_taskId].status == statusCompleted);
		require(_creatorRating <= 10);
		require(tasks[_taskId].creatorRating == 0);

		tasks[_taskId].creatorRating = _creatorRating;
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
