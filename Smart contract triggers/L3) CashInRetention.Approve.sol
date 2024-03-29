//Description: The client can approve the cash-in retention data by updating SC table L3.
//SC conditions: User’s address is in SC table A: Client.
//Etherscan address: https://goerli.etherscan.io/address/0x32253EBb203a34bED5D50F483cD0d833Ebf52ABd

pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

//Name: CashinRetention_Approve

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
interface ICashInRetention {
  struct Data {
    uint256 A_Created;
    uint256 A_Retention;
    uint256 A_Percent;
    uint256 A_DLPmonths;
    string A_Status;
    uint256 A_ReleaseDate;
    string A_PayCode;
    address payable A_RetentionRecipient;
    address A_CashInI_Pointer;
  }
  function AcceptOwnership() external returns(bool);
  function AddPermission(address addr) external returns(bool);
  function Delete(address recordId) external returns(bool);
  function Exists(address recordId) external returns(bool);
  function GetById(address recordId) external returns(uint256,ICashInRetention.Data memory,ICashInI.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,ICashInRetention.Data memory,ICashInI.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(ICashInRetention.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(ICashInRetention.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, ICashInRetention.Data calldata) external returns(bool);
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
  address CashInRetentionAddress = 0x4c04b4d49428Ba359D2c2b61E9296D4a87747B3f;
  address ClientAddress = 0x6Ad768315a7fabca8F8D8Ea475B745532043963B;

  function invoke(address _recordId,ICashInRetention.Data memory CashInRetention_Data) public  returns(bool){

    //Instantiate Global Interfaces
    ICashInRetention CashInRetention = ICashInRetention(CashInRetentionAddress);

    //Declare and Initialize Constant Interfaces
    uint256 CashInRetention_GetById_index;
    ICashInRetention.Data memory CashInRetention_GetById_record;
    ICashInI.Data memory CashInRetention_GetById_R_CashInI_Data;
    (CashInRetention_GetById_index,CashInRetention_GetById_record,CashInRetention_GetById_R_CashInI_Data) = CashInRetention.GetById(_recordId);

    //Required Payment Options

    //Invoke Required Condition Functions
      Condition0(msg.sender);

    //Map Values to Action Interface
    CashInRetention_Data.A_Created = CashInRetention_GetById_record.A_Created;
    CashInRetention_Data.A_Retention = CashInRetention_GetById_record.A_Retention;
    CashInRetention_Data.A_Percent = CashInRetention_GetById_record.A_Percent;
    CashInRetention_Data.A_DLPmonths = CashInRetention_GetById_record.A_DLPmonths;
    CashInRetention_Data.A_Status = 'Approved';
    CashInRetention_Data.A_ReleaseDate = CashInRetention_GetById_record.A_ReleaseDate;
    CashInRetention_Data.A_PayCode = CashInRetention_GetById_record.A_PayCode;
    CashInRetention_Data.A_RetentionRecipient = CashInRetention_GetById_record.A_RetentionRecipient;
    CashInRetention_Data.A_CashInI_Pointer = CashInRetention_GetById_record.A_CashInI_Pointer;

    //Execute Action
    require(CashInRetention.Update(_recordId,CashInRetention_Data));

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
