pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

//Name: PBA_Ins_3
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
interface IPM {
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
  function GetById(address recordId) external returns(uint256,IPM.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,IPM.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(IPM.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(IPM.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, IPM.Data calldata) external returns(bool);
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

  address PBAAddress = 0xCDA9795D036F5d2870E9af50C755E2D938fF83ea;
  address GtorAddress = 0xCd15bDe118c457F0dD7dB5093b4b4A5d82BbF028;
  address MCAddress = 0xBE88b614e8cDE058e7556c4a2F2C4304F26F30ba;
  address PMAddress = 0x119b81e3f96191ba01e516A3a50ee8fD25e09178;
  address CAddress = 0x0f6B0c784eb31Db4FE356439F110b314C7B80621;

  function invoke(IPBA.Data memory PBA_Data) public  returns(bool){

    //Instantiate Global Interfaces
    IPBA PBA = IPBA(PBAAddress);

    //Declare and Initialize Constant Interfaces

    //Required Payment Options

    //Invoke Required Condition Functions
      Condition0(msg.sender);
      Condition1(PBA_Data.A_Address);
      Condition2(PBA_Data.A_Address);
      Condition3(PBA_Data.A_Address);

    //Map Values to Action Interface
    PBA_Data.A_Added = block.timestamp * 1000;
    PBA_Data.A_Role = 'PBA manager';
    PBA_Data.A_ID = '005';
    PBA_Data.A_Contract = '/PBA.pdf';

    //Execute Action
    require(PBA.Insert(PBA_Data));

    //Return Success
    return true;
  }

  //Condition Functions
  function Condition0(address _msgSenderBase) private  {
        IPM PM = IPM(PMAddress);
        bool contains = false;

        for(uint x = 0; x < PM.GetLength(); x++){

          address PM_GetByIndex_recordId;
          IPM.Data memory PM_GetByIndex_record;
          (PM_GetByIndex_recordId,PM_GetByIndex_record) = PM.GetByIndex(x);

            if(_msgSenderBase == PM_GetByIndex_record.A_Address){
              contains = true;
              break;
            }

        }

        require(contains);

  }
  function Condition1(address CBI_Address) private  {
        IC C = IC(CAddress);
        bool contains = false;

        for(uint x = 0; x < C.GetLength(); x++){

          address C_GetByIndex_recordId;
          IC.Data memory C_GetByIndex_record;
          (C_GetByIndex_recordId,C_GetByIndex_record) = C.GetByIndex(x);

            if(CBI_Address == C_GetByIndex_record.A_Address){
              contains = true;
              
            }

        }

        require(!contains);
        
  }
  function Condition2(address CBI_Address) private  {
        IGtor Gtor = IGtor(GtorAddress);
        bool contains = false;

        for(uint x = 0; x < Gtor.GetLength(); x++){

          address Gtor_GetByIndex_recordId;
          IGtor.Data memory Gtor_GetByIndex_record;
          (Gtor_GetByIndex_recordId,Gtor_GetByIndex_record) = Gtor.GetByIndex(x);

            if(CBI_Address == Gtor_GetByIndex_record.A_Address){
              contains = true;
              
            }

        }

        require(!contains);
        
  }
  function Condition3(address CBI_Address) private  {
        IMC MC = IMC(MCAddress);
        bool contains = false;

        for(uint x = 0; x < MC.GetLength(); x++){

          address MC_GetByIndex_recordId;
          IMC.Data memory MC_GetByIndex_record;
          (MC_GetByIndex_recordId,MC_GetByIndex_record) = MC.GetByIndex(x);

            if(CBI_Address == MC_GetByIndex_record.A_Address){
              contains = true;
              
            }

        }

        require(!contains);
        
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
