pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

//Name: CashIn_C_Update_Pay_002
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

interface ICashInI {
  struct Data {
    uint256 A_Added;
    string A_Role;
    uint256 A_ID;
    string A_Contract;
    uint256 A_Milestone;
    uint256 A_Revision;
    uint256 A_Start;
    uint256 A_End;
    uint256 A_Planned;
    uint256 A_Actual;
    string A_CostCode;
    string A_Status;
    uint256 A_PercentageComp;
    uint256 A_DaysBehind;
    uint256 A_Updated;
    address payable A_PBA;
  }
  function AcceptOwnership() external returns(bool);
  function AddPermission(address addr) external returns(bool);
  function Delete(address recordId) external returns(bool);
  function Exists(address recordId) external returns(bool);
  function GetById(address recordId) external returns(uint256,ICashInI.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,ICashInI.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(ICashInI.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(ICashInI.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, ICashInI.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}
interface IClient {
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
  function GetById(address recordId) external returns(uint256,IClient.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,IClient.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(IClient.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(IClient.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, IClient.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}

contract trigger is owned {
  using SafeMath for uint;

  address CashInIAddress = 0x8A17A1fF265734D6ddF240f070a5090B8720F130;
  address ClientAddress = 0x6Ad768315a7fabca8F8D8Ea475B745532043963B;

  function invoke(address _recordId,ICashInI.Data memory CashInI_Data) public payable returns(bool){

    //Instantiate Global Interfaces
    ICashInI CashInI = ICashInI(CashInIAddress);

    //Declare and Initialize Constant Interfaces
    uint256 CashInI_GetById_index;
    ICashInI.Data memory CashInI_GetById_record;
    (CashInI_GetById_index,CashInI_GetById_record) = CashInI.GetById(_recordId);

    //Required Payment Options
    require(msg.value == CashInI_GetById_record.A_Actual);
          payable(CashInI_GetById_record.A_PBA).transfer(msg.value);

    //Invoke Required Condition Functions
      Condition0(msg.sender);

    //Map Values to Action Interface
    CashInI_Data.A_Added = CashInI_GetById_record.A_Added;
    CashInI_Data.A_Role = CashInI_GetById_record.A_Role;
    CashInI_Data.A_ID = CashInI_GetById_record.A_ID;
    CashInI_Data.A_Contract = CashInI_GetById_record.A_Contract;
    CashInI_Data.A_Milestone = CashInI_GetById_record.A_Milestone;
    CashInI_Data.A_Revision = CashInI_GetById_record.A_Revision;
    CashInI_Data.A_Start = CashInI_GetById_record.A_Start;
    CashInI_Data.A_End = CashInI_GetById_record.A_End;
    CashInI_Data.A_Planned = CashInI_GetById_record.A_Planned;
    CashInI_Data.A_Actual = CashInI_GetById_record.A_Actual;
    CashInI_Data.A_CostCode = CashInI_GetById_record.A_CostCode;
    CashInI_Data.A_Status = 'Paid';
    CashInI_Data.A_PercentageComp = CashInI_GetById_record.A_PercentageComp;
    CashInI_Data.A_DaysBehind = CashInI_GetById_record.A_DaysBehind;
    CashInI_Data.A_Updated = block.timestamp * 1000;
    CashInI_Data.A_PBA = CashInI_GetById_record.A_PBA;

    //Execute Action
    require(CashInI.Update(_recordId,CashInI_Data));

    //Return Success
    return true;
  }

  //Condition Functions
  function Condition0(address _msgSenderBase) private  {
        IClient Client = IClient(ClientAddress);
        bool contains = false;

        for(uint x = 0; x < Client.GetLength(); x++){

          address Client_GetByIndex_recordId;
          IClient.Data memory Client_GetByIndex_record;
          (Client_GetByIndex_recordId,Client_GetByIndex_record) = Client.GetByIndex(x);

            if(_msgSenderBase == Client_GetByIndex_record.A_Wallet){
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
