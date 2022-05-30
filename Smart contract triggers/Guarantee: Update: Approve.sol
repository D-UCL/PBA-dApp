pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

//Name: Gtee_UpApp_G_4
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

interface IGteeII {
  struct Data {
    uint256 A_Added;
    string A_Reference;
    uint256 A_Guarantee;
    string A_Status;
    string A_Contract;
    uint256 A_Approved;
    address payable A_PBA;
  }
  function AcceptOwnership() external returns(bool);
  function AddPermission(address addr) external returns(bool);
  function Delete(address recordId) external returns(bool);
  function Exists(address recordId) external returns(bool);
  function GetById(address recordId) external returns(uint256,IGteeII.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,IGteeII.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(IGteeII.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(IGteeII.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, IGteeII.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}
interface IGtor {
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
  function GetById(address recordId) external returns(uint256,IGtor.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,IGtor.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(IGtor.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(IGtor.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, IGtor.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}

contract trigger is owned {
  using SafeMath for uint;

  address GteeIIAddress = 0x0b3AD6A46029E2F1A78eA1E244D3571EB75d7667;
  address GtorAddress = 0xCd15bDe118c457F0dD7dB5093b4b4A5d82BbF028;

  function invoke(address _recordId,IGteeII.Data memory GteeII_Data) public  returns(bool){

    //Instantiate Global Interfaces
    IGteeII GteeII = IGteeII(GteeIIAddress);

    //Declare and Initialize Constant Interfaces
    uint256 GteeII_GetById_index;
    IGteeII.Data memory GteeII_GetById_record;
    (GteeII_GetById_index,GteeII_GetById_record) = GteeII.GetById(_recordId);

    //Required Payment Options

    //Invoke Required Condition Functions
      Condition0(msg.sender);

    //Map Values to Action Interface
    GteeII_Data.A_Added = GteeII_GetById_record.A_Added;
    GteeII_Data.A_Reference = GteeII_GetById_record.A_Reference;
    GteeII_Data.A_Guarantee = GteeII_GetById_record.A_Guarantee;
    GteeII_Data.A_Status = 'Approved';
    GteeII_Data.A_Contract = GteeII_GetById_record.A_Contract;
    GteeII_Data.A_Approved = block.timestamp * 1000;
    GteeII_Data.A_PBA = GteeII_GetById_record.A_PBA;

    //Execute Action
    require(GteeII.Update(_recordId,GteeII_Data));

    //Return Success
    return true;
  }

  //Condition Functions
  function Condition0(address _msgSenderBase) private  {
        IGtor Gtor = IGtor(GtorAddress);
        bool contains = false;

        for(uint x = 0; x < Gtor.GetLength(); x++){

          address Gtor_GetByIndex_recordId;
          IGtor.Data memory Gtor_GetByIndex_record;
          (Gtor_GetByIndex_recordId,Gtor_GetByIndex_record) = Gtor.GetByIndex(x);

            if(_msgSenderBase == Gtor_GetByIndex_record.A_Address){
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
