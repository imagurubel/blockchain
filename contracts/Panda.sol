pragma solidity ^0.4.19;

contract Panda {

	uint constant statusCreated = 1;
	uint constant statusConfirmed = 2;
	uint constant statusResultSubmitted = 3;
	uint constant statusCompleted = 4;
	uint constant minServiceFee = 10000000000000000; // 0.01 ETH

	uint public lastTaskId;

	struct Task {
		uint status;
		bytes taskHash;
		address creator;
		address performer;
		uint value;
		bytes resultHash;
		uint createdAt;
		uint confirmedAt;
		uint resultSubmittedAt;
		uint completedAt;
		uint creatorRating;
		uint performerRating;
	}

	mapping (uint256 => Task) public tasks;

	mapping (address => bool) public whitelist;



	function taskCreate(bytes _taskHash, address _performer) public payable {
		require(msg.value > minServiceFee);
		require(whitelist[_performer]);

		lastTaskId = lastTaskId + 1;
		tasks[lastTaskId].status = statusCreated;
		tasks[lastTaskId].creator = msg.sender;
		tasks[lastTaskId].taskHash = _taskHash;
		tasks[lastTaskId].performer = _performer;
		tasks[lastTaskId].value = msg.value;
		tasks[lastTaskId].createdAt = block.timestamp;
	}


	function taskConfirm(uint _taskId) public {
		require(tasks[_taskId].performer == msg.sender);
		require(tasks[_taskId].status == statusCreated);

		tasks[_taskId].status = statusConfirmed;
		tasks[lastTaskId].confirmedAt = block.timestamp;
	}


	function taskSubmitResult(uint _taskId, bytes _resultHash) public {
		require(tasks[_taskId].performer == msg.sender);
		require(tasks[_taskId].status == statusConfirmed
			|| tasks[_taskId].status == statusResultSubmitted);

		tasks[_taskId].status = statusResultSubmitted;
		tasks[_taskId].resultHash = _resultHash;
		tasks[lastTaskId].resultSubmittedAt = block.timestamp;
	}


	function taskCompleteSuccessfully(uint _taskId) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusResultSubmitted);

		tasks[_taskId].status = statusCompleted;
		tasks[_taskId].completedAt = block.timestamp;

		tasks[_taskId].performer.transfer(tasks[_taskId].value - minServiceFee);
	}


	function taskRatePerformer(uint _taskId, uint _rating) public {
		require(tasks[_taskId].creator == msg.sender);
		require(tasks[_taskId].status == statusCompleted);
		require(_rating <= 10);
		require(tasks[_taskId].performerRating == 0);

		tasks[_taskId].performerRating = _rating;
	}


	function taskRateCreator(uint _taskId, uint _rating) public {
		require(tasks[_taskId].performer == msg.sender);
		require(tasks[_taskId].status == statusCompleted);
		require(_rating <= 10);
		require(tasks[_taskId].creatorRating == 0);

		tasks[_taskId].creatorRating = _rating;
	}


	constructor() public {
		ownerAddress = msg.sender;
	}

	address public ownerAddress;

	modifier onlyOwner() {
		require(msg.sender == ownerAddress);
		_;
	}

	function setWhitelist(address _address, bool _status) external onlyOwner {
		whitelist[_address] = _status;
	}

}
