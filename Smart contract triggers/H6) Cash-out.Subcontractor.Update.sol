pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

//Name: Sch_Sub_Update
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
interface ISubC {
  struct Data {
    uint256 A_Added;
    string A_Role;
    string A_ID;
    string A_Contract;
    address payable A_Address;
  }
  function AcceptOwnership() external returns(bool);
  function AddPermission(address addr) external returns(bool);
  function Delete(address recordId) external returns(bool);
  function Exists(address recordId) external returns(bool);
  function GetById(address recordId) external returns(uint256,ISubC.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,ISubC.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(ISubC.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(ISubC.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, ISubC.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}

contract trigger is owned {
  using SafeMath for uint;

  address ScheduleIIIAddress = 0xd1731B97F15b69f5b6d673eFD249D87c467D02B0;
  address SubCAddress = 0xB214ffbBAeAF5271B626216D2Fdbb48e3b93CaC4;

  function invoke(address _recordId,IScheduleIII.Data memory ScheduleIII_Data) public  returns(bool){

    //Instantiate Global Interfaces
    IScheduleIII ScheduleIII = IScheduleIII(ScheduleIIIAddress);

    //Declare and Initialize Constant Interfaces
    uint256 ScheduleIII_GetById_index;
    IScheduleIII.Data memory ScheduleIII_GetById_record;
    (ScheduleIII_GetById_index,ScheduleIII_GetById_record) = ScheduleIII.GetById(_recordId);

    //Required Payment Options

    //Invoke Required Condition Functions
      Condition0(msg.sender);

    //Map Values to Action Interface
    ScheduleIII_Data.A_Added = ScheduleIII_GetById_record.A_Added;
    ScheduleIII_Data.A_ID = ScheduleIII_GetById_record.A_ID;
    ScheduleIII_Data.A_Role = ScheduleIII_GetById_record.A_Role;
    ScheduleIII_Data.A_Works = ScheduleIII_GetById_record.A_Works;
    ScheduleIII_Data.A_Contract = ScheduleIII_GetById_record.A_Contract;
    ScheduleIII_Data.A_Planned = ScheduleIII_GetById_record.A_Planned;
    ScheduleIII_Data.A_Actual = ScheduleIII_GetById_record.A_Actual;
    ScheduleIII_Data.A_Complete = ScheduleIII_GetById_record.A_Complete;
    ScheduleIII_Data.A_Status = 'Complete';
    ScheduleIII_Data.A_CostCode = ScheduleIII_GetById_record.A_CostCode;
    ScheduleIII_Data.A_Start = ScheduleIII_GetById_record.A_Start;
    ScheduleIII_Data.A_End = ScheduleIII_GetById_record.A_End;
    ScheduleIII_Data.A_Payee = ScheduleIII_GetById_record.A_Payee;

    //Execute Action
    require(ScheduleIII.Update(_recordId,ScheduleIII_Data));

    //Return Success
    return true;
  }

  //Condition Functions
  function Condition0(address _msgSenderBase) private  {
        ISubC SubC = ISubC(SubCAddress);
        bool contains = false;

        for(uint x = 0; x < SubC.GetLength(); x++){

          address SubC_GetByIndex_recordId;
          ISubC.Data memory SubC_GetByIndex_record;
          (SubC_GetByIndex_recordId,SubC_GetByIndex_record) = SubC.GetByIndex(x);

            if(_msgSenderBase == SubC_GetByIndex_record.A_Address){
              contains = true;
              break;
            }

        }

        require(contains);

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
