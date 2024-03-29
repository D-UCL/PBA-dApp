//Description: Enables the subs’ to update SC table H: Cash-out to alert tier-one parties that they have completed works on-site.
//SC conditions: User’s address is in SC table F: Subcontractor.
//Etherscan address: https://goerli.etherscan.io/address/0x2953cD74aD335D5a0F87c907beA5439D49B47404

pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

//Name: CashOut_Sub_Update_Accept

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

interface ICashoutII {
  struct Data {
    uint256 A_Added;
    string A_Role;
    uint256 A_ID;
    string A_Contract;
    string A_Works;
    uint256 A_Revision;
    uint256 A_Start;
    uint256 A_End;
    uint256 A_Planned;
    uint256 A_Actual;
    string A_CostCode;
    string A_Status;
    uint256 A_PercentageComp;
    uint256 A_DaysBehind;
    uint256 A_LastUpdate;
    address payable A_Payee;
  }
  function AcceptOwnership() external returns(bool);
  function AddPermission(address addr) external returns(bool);
  function Delete(address recordId) external returns(bool);
  function Exists(address recordId) external returns(bool);
  function GetById(address recordId) external returns(uint256,ICashoutII.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,ICashoutII.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(ICashoutII.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(ICashoutII.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, ICashoutII.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}
interface ISubcontractor {
  struct Data {
    uint256 A_Added;
    string A_Role;
    string A_ID;
    string A_Contract;
    address payable A_Wallet;
  }
  function AcceptOwnership() external returns(bool);
  function AddPermission(address addr) external returns(bool);
  function Delete(address recordId) external returns(bool);
  function Exists(address recordId) external returns(bool);
  function GetById(address recordId) external returns(uint256,ISubcontractor.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,ISubcontractor.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(ISubcontractor.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(ISubcontractor.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, ISubcontractor.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}

contract trigger is owned {
  using SafeMath for uint;

  address CashoutIIAddress = 0xbb93F9eA1BaB92F71EF8A796f75ce586aC85AAb6;
  address SubcontractorAddress = 0x513E81F9CC57B65113D5216e5fC3ef1e7784EFFC;

  function invoke(address _recordId,ICashoutII.Data memory CashoutII_Data) public  returns(bool){

    //Instantiate Global Interfaces
    ICashoutII CashoutII = ICashoutII(CashoutIIAddress);

    //Declare and Initialize Constant Interfaces
    uint256 CashoutII_GetById_index;
    ICashoutII.Data memory CashoutII_GetById_record;
    (CashoutII_GetById_index,CashoutII_GetById_record) = CashoutII.GetById(_recordId);

    //Required Payment Options

    //Invoke Required Condition Functions
      Condition0(msg.sender);

    //Map Values to Action Interface
    CashoutII_Data.A_Added = CashoutII_GetById_record.A_Added;
    CashoutII_Data.A_Role = CashoutII_GetById_record.A_Role;
    CashoutII_Data.A_ID = CashoutII_GetById_record.A_ID;
    CashoutII_Data.A_Contract = CashoutII_GetById_record.A_Contract;
    CashoutII_Data.A_Works = CashoutII_GetById_record.A_Works;
    CashoutII_Data.A_Revision = CashoutII_GetById_record.A_Revision;
    CashoutII_Data.A_Start = CashoutII_GetById_record.A_Start;
    CashoutII_Data.A_End = CashoutII_GetById_record.A_End;
    CashoutII_Data.A_Planned = CashoutII_GetById_record.A_Planned;
    CashoutII_Data.A_Actual = CashoutII_GetById_record.A_Actual;
    CashoutII_Data.A_CostCode = CashoutII_GetById_record.A_CostCode;
    CashoutII_Data.A_Status = 'Accepted';
    CashoutII_Data.A_PercentageComp = CashoutII_GetById_record.A_PercentageComp;
    CashoutII_Data.A_DaysBehind = CashoutII_GetById_record.A_DaysBehind;
    CashoutII_Data.A_LastUpdate = CashoutII_GetById_record.A_LastUpdate;
    CashoutII_Data.A_Payee = CashoutII_GetById_record.A_Payee;

    //Execute Action
    require(CashoutII.Update(_recordId,CashoutII_Data));

    //Return Success
    return true;
  }

  //Condition Functions
  function Condition0(address _msgSenderBase) private  {
        ISubcontractor Subcontractor = ISubcontractor(SubcontractorAddress);
        bool contains = false;

        for(uint x = 0; x < Subcontractor.GetLength(); x++){

          address Subcontractor_GetByIndex_recordId;
          ISubcontractor.Data memory Subcontractor_GetByIndex_record;
          (Subcontractor_GetByIndex_recordId,Subcontractor_GetByIndex_record) = Subcontractor.GetByIndex(x);

            if(_msgSenderBase == Subcontractor_GetByIndex_record.A_Wallet){
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
