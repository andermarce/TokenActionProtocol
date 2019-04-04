pragma solidity ^0.5.6;

// import libs
import './libs/SafeMath.sol';
// import interfaces
import './registryService/IConfirmOwner.sol';
import './token/erc20/IERC20.sol';
import './token/erc20/FIERC20.sol';
import './IOwnable.sol';
import './ITAP.sol';
// import contracts
import './Ownable.sol';
import './Withdrawal.sol';

/**
 * @title Implementation of Token Action Protocol.
 * @author Paul Bolhar <paul.bolhar@gmail.com>
 */
contract TokenActionProtocol is ITAP, Ownable, Withdrawal
{
    using SafeMath for uint;

    IERC20 public erc20;

    uint256 public issuanceTime; // creation timestamp
    uint256 public oneAction;
    uint256 public minWithdrawTime;
    uint256 public minWithdrawalBalance;

    mapping (address=>uint256) internal rightholders; // address=>balance - storage
    mapping (address=>uint256) internal lastWithdraw; // address=>timestamp - storage
    mapping (address => uint256) public lastAccumulatedBalance; // address=>balance - storage known last user withdrawal balance

    /**
     *   @dev Restriction by the time on user actions.;
    */
    modifier isTime() {
        if(0 == lastWithdraw[msg.sender]) {
            require(now.sub(issuanceTime) > minWithdrawTime);
        } else {
            require(now.sub(lastWithdraw[msg.sender]) > minWithdrawTime);
        }
        _;
    }

    /**
     *   @dev Restriction by the time on user actions.;
    */
    modifier isRightholder() {
        require(rightsOf(msg.sender) >= oneAction);
        _;
    }

    /**
      *  @dev Restriction by the time on user actions.;
    */
    modifier isTokenHolder(address _recipient, uint256 _amount) {
        require(erc20.balanceOf(_recipient) >= _amount);
        _;
    }

    /**
      *  @dev Contract constructor.;
      *  @param _token - erc20 supported token contract address
      *  @param _minWithdrawTime -  minimal withdraw time, natural number from 1 to x, where x is 1 month
      *  @param _minWithdrawalBalance - minimal withdrawal balance (set more then 100*10*10**9)

    */
    constructor(
        address _token,
        uint256 _minWithdrawTime,
        uint256 _minWithdrawalBalance
    ) public {
        require(_token != address(0) && contractValidator != address(0));
        erc20 = IERC20(_token);
        minWithdrawTime = _minWithdrawTime * 30 days; // default x * 1 month
        oneAction = 1*10**uint256(FIERC20(_token).decimals());
        minWithdrawalBalance = _minWithdrawalBalance * oneAction; // equivalent 1 action
        issuanceTime = now;
    }

    // state storage
    bool internal validatorState = false;

    // third part trusted contract validator
    address public contractValidator;

    // state modifier, prevent action issue, prevent not valid contract
    modifier isValidatorSet() {
        require(validatorState);
        _;
    }
    
    /**
     * @dev Set validator contract
    */
    function setValidator(address _validator) public onlyOwner returns (bool) {
        contractValidator = _validator;
        return true;
    }

    /**
     * @dev Issue action on token owner balance
     */
    function issueAction() public isValidatorSet returns (bool) {
        IConfOwner(contractValidator).isTokenOwner(_token);
        _owner = msg.sender; // set valid owner
        rightholders[msg.sender] = erc20.totalSupply(); // give all rights to owner
        return true;
    }

    /**
      *  @dev count withdraw balance.;
    */
    function _countWB() internal view returns (uint256) {
        uint256 diffBalance = getAccumulatedBalance().sub(lastAccumulatedBalance[msg.sender]);
        uint256 totalSupply = erc20.totalSupply();
        return diffBalance.div(totalSupply.div((rightsOf(msg.sender).div(oneAction)).mul(oneAction)));
    }

    function _update() internal {
        lastWithdraw[msg.sender] = now; // upd withdraw time
        lastAccumulatedBalance[msg.sender] = getAccumulatedBalance(); // upd accum balance
    }

    function _transferOfRights(address _to, uint256 _amount)
    internal
    returns (bool)
    {
        require(_to != address(0));
        //require(erc20.balanceOf(_to) < _amount);
        rightholders[msg.sender] = rightholders[msg.sender].sub(_amount);
        rightholders[_to] = rightholders[_to].add(_amount);
        emit RightsTransfer(msg.sender, _to, _amount);
        return true;
    }

    function transferOfRights(address _to, uint256 _amount) public
    isRightholder // only owner of active can init transaction
    isTokenHolder(_to, _amount) // only holder of token can get rights
    returns (bool)
    {
        return _transferOfRights(_to, _amount);
    }

    function rightToTransfer(address _from, address _to, uint256 _amount) public returns (bool) {
        // not implimented
        return true;
    }

    function transferWithRights(address _to, uint256 _amount) public returns (bool) {
        if(transferOfRights(_to, _amount)) {
            erc20.transfer(_to, _amount);
            return true;
        } else {
            return false;
        }
    }

    function rightsOf(address rightholder) public view returns (uint256) {
        return rightholders[rightholder];
    }

    function getDividends() public
    isTime // no more than minimum time range
    isRightholder // only rightholder
    returns (bool)
    {
        uint256 amount = _countWB();
        prepareWithdrawal(amount);
        _update();
        return true;
    }

    function testBalance(address _who) public view returns (uint256, uint256) {
        return (erc20.balanceOf(_who), rightsOf(_who));
    }
}
