pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

//Name: View_ins
//Description: 

contract owned {
  address public owner;
  address public newOwner;
  address[] public permissionedList;

  event OwnershipTransferred(address _from, address _to);
  event PermissionAdded(address _address);
  event PermissionRevoked(address _address);

  constructor() public {
      owner = msg.sender;
  }

  modifier isOwner {
      require(msg.sender == owner);
      _;
  }

  modifier authorized {
      require(HasPermission(msg.sender));
      _;
  }

  function TransferOwnership(address _newOwner) public isOwner returns(bool success){
      newOwner = _newOwner;
      return true;
  }
  function AcceptOwnership() public returns(bool success){
      require(msg.sender == newOwner);
      owner = newOwner;
      newOwner = address(0);
      emit OwnershipTransferred(owner, newOwner);
      return true;
  }

  function AddPermission(address addr) public isOwner returns(bool success){
      permissionedList.push(addr);
      emit PermissionAdded(addr);
      return true;
  }

  function RemovePermission(address addr) public isOwner returns(bool success){
      for(uint x = 0; x < permissionedList.length; x++){
          if(addr == permissionedList[x]){
              address keepPermission = permissionedList[permissionedList.length - 1];
              permissionedList[x] = keepPermission;
              permissionedList.pop();
              emit PermissionRevoked(addr);
              return true;
          }
      }
      return false;

  }

  function HasPermission(address sender) public view returns(bool permission){
      if(sender == owner){
          return true;
      }

      for(uint x = 0; x < permissionedList.length; x++){
          if(sender == permissionedList[x]){
              return true;
          }
      }
      return false;
  }

  function GetPermissionListLength() public view returns(uint length){
    return permissionedList.length;
  }

  function GetPermission(uint index) public view returns(address permissionAddress){
    return permissionedList[index];
  }
}

interface IScheduleIII {
  struct Data {
    uint256 A_Added;
    string A_ID;
    string A_Role;
    string A_Works;
    string A_Contract;
    uint256 A_Planned;
    uint256 A_Actual;
    string A_Complete;
    string A_Status;
    string A_CostCode;
    uint256 A_Start;
    uint256 A_End;
    address payable A_Payee;
  }
  function AcceptOwnership() external returns(bool);
  function AddPermission(address addr) external returns(bool);
  function Delete(address recordId) external returns(bool);
  function Exists(address recordId) external returns(bool);
  function GetById(address recordId) external returns(uint256,IScheduleIII.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,IScheduleIII.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(IScheduleIII.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(IScheduleIII.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, IScheduleIII.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}
interface IViewII {
  struct Data {
    address payable A_Wallet;
    address A_ScheduleIII_Pointer;
  }
  function AcceptOwnership() external returns(bool);
  function AddPermission(address addr) external returns(bool);
  function Delete(address recordId) external returns(bool);
  function Exists(address recordId) external returns(bool);
  function GetById(address recordId) external returns(uint256,IViewII.Data memory,IScheduleIII.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,IViewII.Data memory,IScheduleIII.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(IViewII.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(IViewII.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, IViewII.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}

contract trigger is owned {
  using SafeMath for uint;

  address ScheduleIIIAddress = 0xd1731B97F15b69f5b6d673eFD249D87c467D02B0;
  address ViewIIAddress = 0x556EB83f818EA4e0F50c7C37696446B23AcC9C8f;

  function invoke(IViewII.Data memory ViewII_Data) public  returns(bool){

    //Instantiate Global Interfaces
    IViewII ViewII = IViewII(ViewIIAddress);

    //Declare and Initialize Constant Interfaces

    //Required Payment Options

    //Invoke Required Condition Functions
      Condition0(msg.sender);

    //Map Values to Action Interface
    ViewII_Data.A_Wallet = payable(msg.sender);
    ViewII_Data.A_ScheduleIII_Pointer = FindRecordId(msg.sender);

    //Execute Action
    require(ViewII.Insert(ViewII_Data));

    //Return Success
    return true;
  }

  //Condition Functions
  function Condition0(address _msgSenderBase) private  {
        IScheduleIII ScheduleIII = IScheduleIII(ScheduleIIIAddress);
        bool contains = false;

        for(uint x = 0; x < ScheduleIII.GetLength(); x++){

          address ScheduleIII_GetByIndex_recordId;
          IScheduleIII.Data memory ScheduleIII_GetByIndex_record;
          (ScheduleIII_GetByIndex_recordId,ScheduleIII_GetByIndex_record) = ScheduleIII.GetByIndex(x);

            if(_msgSenderBase == ScheduleIII_GetByIndex_record.A_Payee){
              contains = true;
              break;
            }

        }

        require(contains);

  }

  //Automap Function
  function FindRecordId(address addr) public returns (address)  {
    IScheduleIII ScheduleIII = IScheduleIII(ScheduleIIIAddress);

    for(uint x = 0; x < ScheduleIII.GetLength(); x++) {

      address ScheduleIII_GetByIndex_recordId;
      IScheduleIII.Data memory ScheduleIII_GetByIndex_record;
      (ScheduleIII_GetByIndex_recordId,ScheduleIII_GetByIndex_record) = ScheduleIII.GetByIndex(x);

      if(addr == ScheduleIII_GetByIndex_record.A_Payee){
        return ScheduleIII_GetByIndex_recordId;
      }

    }
    require(false, 'record-not-found');

  }

}
library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
}
