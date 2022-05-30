pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

//Name: mPBA_approve
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

interface ImainPBA {
  struct Data {
    uint256 A_Added;
    string A_Milestone;
    string A_Revision;
    uint256 A_Planned;
    uint256 A_Actual;
    string A_Schedule;
    string A_Status;
    uint256 A_From;
    uint256 A_To;
    address payable A_PBA;
  }
  function AcceptOwnership() external returns(bool);
  function AddPermission(address addr) external returns(bool);
  function Delete(address recordId) external returns(bool);
  function Exists(address recordId) external returns(bool);
  function GetById(address recordId) external returns(uint256,ImainPBA.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,ImainPBA.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(ImainPBA.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(ImainPBA.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, ImainPBA.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}
interface IC {
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
  function GetById(address recordId) external returns(uint256,IC.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,IC.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(IC.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(IC.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, IC.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}

contract trigger is owned {
  using SafeMath for uint;

  address mainPBAAddress = 0x7fdaC39251B63EE8078292E2B612B7fbb68DaA45;
  address CAddress = 0x0f6B0c784eb31Db4FE356439F110b314C7B80621;

  function invoke(address _recordId,ImainPBA.Data memory mainPBA_Data) public  returns(bool){

    //Instantiate Global Interfaces
    ImainPBA mainPBA = ImainPBA(mainPBAAddress);

    //Declare and Initialize Constant Interfaces
    uint256 mainPBA_GetById_index;
    ImainPBA.Data memory mainPBA_GetById_record;
    (mainPBA_GetById_index,mainPBA_GetById_record) = mainPBA.GetById(_recordId);

    //Required Payment Options

    //Invoke Required Condition Functions
      Condition0(msg.sender);

    //Map Values to Action Interface
    mainPBA_Data.A_Added = mainPBA_GetById_record.A_Added;
    mainPBA_Data.A_Milestone = mainPBA_GetById_record.A_Milestone;
    mainPBA_Data.A_Revision = mainPBA_GetById_record.A_Revision;
    mainPBA_Data.A_Planned = mainPBA_GetById_record.A_Planned;
    mainPBA_Data.A_Actual = mainPBA_GetById_record.A_Actual;
    mainPBA_Data.A_Schedule = mainPBA_GetById_record.A_Schedule;
    mainPBA_Data.A_Status = 'Approved';
    mainPBA_Data.A_From = mainPBA_GetById_record.A_From;
    mainPBA_Data.A_To = mainPBA_GetById_record.A_To;
    mainPBA_Data.A_PBA = mainPBA_GetById_record.A_PBA;

    //Execute Action
    require(mainPBA.Update(_recordId,mainPBA_Data));

    //Return Success
    return true;
  }

  //Condition Functions
  function Condition0(address _msgSenderBase) private  {
        IC C = IC(CAddress);
        bool contains = false;

        for(uint x = 0; x < C.GetLength(); x++){

          address C_GetByIndex_recordId;
          IC.Data memory C_GetByIndex_record;
          (C_GetByIndex_recordId,C_GetByIndex_record) = C.GetByIndex(x);

            if(_msgSenderBase == C_GetByIndex_record.A_Address){
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
