pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

//Name: Gtee_ins
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
interface IMC {
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
  function GetById(address recordId) external returns(uint256,IMC.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,IMC.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(IMC.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(IMC.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, IMC.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}
interface IPBA {
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
  function GetById(address recordId) external returns(uint256,IPBA.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,IPBA.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(IPBA.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(IPBA.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, IPBA.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}

contract trigger is owned {
  using SafeMath for uint;

  address GteeIIAddress = 0x0b3AD6A46029E2F1A78eA1E244D3571EB75d7667;
  address MCAddress = 0xBE88b614e8cDE058e7556c4a2F2C4304F26F30ba;
  address PBAAddress = 0xCDA9795D036F5d2870E9af50C755E2D938fF83ea;

  function invoke(IGteeII.Data memory GteeII_Data) public  returns(bool){

    //Instantiate Global Interfaces
    IGteeII GteeII = IGteeII(GteeIIAddress);

    //Declare and Initialize Constant Interfaces

    //Required Payment Options

    //Invoke Required Condition Functions
      Condition0(msg.sender);
      Condition1(GteeII_Data.A_PBA);

    //Map Values to Action Interface
    GteeII_Data.A_Added = block.timestamp * 1000;
    GteeII_Data.A_Status = 'Pending';
    GteeII_Data.A_Contract = '/G.pdf';
    GteeII_Data.A_Approved = block.timestamp * 1000;

    //Execute Action
    require(GteeII.Insert(GteeII_Data));

    //Return Success
    return true;
  }

  //Condition Functions
  function Condition0(address _msgSenderBase) private  {
        IMC MC = IMC(MCAddress);
        bool contains = false;

        for(uint x = 0; x < MC.GetLength(); x++){

          address MC_GetByIndex_recordId;
          IMC.Data memory MC_GetByIndex_record;
          (MC_GetByIndex_recordId,MC_GetByIndex_record) = MC.GetByIndex(x);

            if(_msgSenderBase == MC_GetByIndex_record.A_Address){
              contains = true;
              break;
            }

        }

        require(contains);

  }
  function Condition1(address CBI_PBA) private  {
        IPBA PBA = IPBA(PBAAddress);
        bool contains = false;

        for(uint x = 0; x < PBA.GetLength(); x++){

          address PBA_GetByIndex_recordId;
          IPBA.Data memory PBA_GetByIndex_record;
          (PBA_GetByIndex_recordId,PBA_GetByIndex_record) = PBA.GetByIndex(x);

            if(CBI_PBA == PBA_GetByIndex_record.A_Address){
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
