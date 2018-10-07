pragma solidity ^0.4.19;

import './lib/oneStepGame.sol';



contract myDAppGame is oneStepGame {

    struct Game {
        uint dataSize;
        uint rate;
        uint min;
        uint max;
        bool exists;
    }

    mapping (uint => Game) public games;
    uint public gamesCount;

    /**
    @notice constructor
    @param _token address of token contract
    @param _ref address of referrer contract
    @param _gameWL address of games whitelist contract
    @param _playerWL address of players whitelist contract
    @param _rsa address of rsa contract
    */
    constructor (
        ERC20Interface _token,
        RefInterface _ref,
        GameWLinterface _gameWL,
        PlayerWLinterface _playerWL,
        RSA _rsa
    )
        oneStepGame(_token, _ref, _gameWL, _playerWL, _rsa) public
    {
        developer = 0x42;
        
        config = Config({
            maxBet: 100 ether,
            minBet: 1,
            gameDevReward: 25,
            bankrollReward: 25,
            platformReward: 25,
            refererReward: 25
        });

        _addGame(2, 6, 1, 6);
        _addGame(2, 15, 1, 15);
        _addGame(4, 5, 1, 15);
        _addGame(6, 3, 1, 15);

    }


    function _addGame(uint _dataSize, uint _rate, uint _min, uint _max) internal returns (bool) {
        games[gamesCount] = Game({
            dataSize : _dataSize,
            rate: _rate,
            min: _min,
            max: _max,
            exists: true
        });

        gamesCount++;

        return true;
    }

   /** 
    @notice interface for check game data
    @param _gameData Player's game data
    @param _bet Player's bet
    @return result boolean
    */
    function checkGameData(uint[] _gameData, uint _bet) public view returns (bool) {
        uint _gameType = _gameData[0];
        require(games[_gameType].exists);
        require(_gameData.length == games[_gameType].dataSize);
        require(_bet >= config.minBet && _bet <= config.maxBet);
        //require(playerNumber > 0 && playerNumber < 64226);
        return true;
    }

    /** 
    @notice interface for game logic
    @param _gameData Player's game data
    @param _bet Player's bet
    @param _sigseed random seed for generate rnd
    */
    function game(uint[] _gameData, uint _bet, bytes _sigseed) public view returns(bool _win, uint _amount) {   
        checkGameData(_gameData, _bet);
        uint _gameType = _gameData[0];

        uint _min = 1;
        uint _max = 15;
        uint _rndNumber = generateRnd(_sigseed, games[_gameType].min, games[_gameType].max);


        uint _profit = getProfit(_gameData, _bet);

        // Game logic

        for (uint i = 2; i <= games[_gameType].dataSize; i++) {
            if (_gameData[i] == _rndNumber) {
                return(true, _profit);
            }
        }

        return(false, _bet);

    }

    /** 
    @notice profit calculation
    @param _gameData Player's game data
    @param _bet Player's bet
    @return profit
    */
    function getProfit(uint[] _gameData, uint _bet) public view returns(uint _profit) {
        uint _gameType = _gameData[0];
        _profit = (_bet * games[_gameType].rate).sub(_bet);
    }

    /**
    @notice Generate random number from sig
    @param _sigseed Sign hash for creation random number
    @param _min Minimal random number
    @param _max Maximal random number
    @return random number
    */
    function generateRnd(bytes _sigseed, uint _min, uint _max) public pure returns(uint) {
        require(_max < 2**128);
        return uint256(keccak256(_sigseed)) % (_max.sub(_min).add(1)).add(_min);
    }
}