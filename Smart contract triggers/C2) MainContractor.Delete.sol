pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

//Name: CashOut_MC_Del_001
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
interface IMainContractor {
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
  function GetById(address recordId) external returns(uint256,IMainContractor.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,IMainContractor.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(IMainContractor.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(IMainContractor.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, IMainContractor.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}
interface ISubcWorksII {
  struct Data {
    address payable A_Address;
    address A_CashoutII_Pointer;
  }
  function AcceptOwnership() external returns(bool);
  function AddPermission(address addr) external returns(bool);
  function Delete(address recordId) external returns(bool);
  function Exists(address recordId) external returns(bool);
  function GetById(address recordId) external returns(uint256,ISubcWorksII.Data memory,ISubcWorksII.Data memory);
  function GetByIndex(uint256 recordIndex) external returns(address,ISubcWorksII.Data memory,ISubcWorksII.Data memory);
  function GetLength() external returns(uint256);
  function GetPermission(uint256 index) external returns(address);
  function GetPermissionListLength() external returns(uint256);
  function HasPermission(address sender) external returns(bool);
  function IdList(uint256 ) external returns(address);
  function Insert(ISubcWorksII.Data calldata) external returns(bool);
  function Name() external returns(string memory);
  function RemovePermission(address addr) external returns(bool);
  function Table(address ) external returns(ISubcWorksII.Data memory,uint256);
  function TransferOwnership(address _newOwner) external returns(bool);
  function Update(address recordId, ISubcWorksII.Data calldata) external returns(bool);
  function newOwner() external returns(address);
  function owner() external returns(address);
  function permissionedList(uint256 ) external returns(address);
}

contract trigger is owned {
  using SafeMath for uint;

  address CashoutIIAddress = 0xbb93F9eA1BaB92F71EF8A796f75ce586aC85AAb6;
  address MainContractorAddress = 0xdC032b81464e64b3592335DF8185799283dC23c7;
  address SubcWorksIIAddress = 0x17e183D7457713483001156994A9ECe3458d03B8;

  function invoke(address _recordId) public  returns(bool){

    //Instantiate Global Interfaces
    ICashoutII CashoutII = ICashoutII(CashoutIIAddress);

    //Declare and Initialize Constant Interfaces
    uint256 CashoutII_GetById_index;
    ICashoutII.Data memory CashoutII_GetById_record;
    (CashoutII_GetById_index,CashoutII_GetById_record) = CashoutII.GetById(_recordId);

    //Required Payment Options

    //Invoke Required Condition Functions
      Condition0(msg.sender);
      Condition1(CashoutII_GetById_record.A_Payee);

    //Map Values to Action Interface

    //Execute Action
    require(CashoutII.Delete(_recordId));

    //Return Success
    return true;
  }

  //Condition Functions
  function Condition0(address _msgSenderBase) private  {
        IMainContractor MainContractor = IMainContractor(MainContractorAddress);
        bool contains = false;

        for(uint x = 0; x < MainContractor.GetLength(); x++){

          address MainContractor_GetByIndex_recordId;
          IMainContractor.Data memory MainContractor_GetByIndex_record;
          (MainContractor_GetByIndex_recordId,MainContractor_GetByIndex_record) = MainContractor.GetByIndex(x);

            if(_msgSenderBase == MainContractor_GetByIndex_record.A_Wallet){
              contains = true;
              break;
            }

        }

        require(contains);

  }
  function Condition1(address CBA_Payee) private  {
        ISubcWorksII SubcWorksII = ISubcWorksII(SubcWorksIIAddress);
        bool contains = false;

        for(uint x = 0; x < SubcWorksII.GetLength(); x++){

          address SubcWorksII_GetByIndex_recordId;
          ISubcWorksII.Data memory SubcWorksII_GetByIndex_record;
          ISubcWorksII.Data memory SubcWorksII_GetByIndex_R_CashoutII_Data;
          (SubcWorksII_GetByIndex_recordId,SubcWorksII_GetByIndex_record,SubcWorksII_GetByIndex_R_CashoutII_Data) = SubcWorksII.GetByIndex(x);

            if(CBA_Payee == SubcWorksII_GetByIndex_record.A_Address){
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
