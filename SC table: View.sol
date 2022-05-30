pragma solidity ^0.8.4;
pragma experimental ABIEncoderV2;

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
    require(msg.sender == owner, 'denied-owner');
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
    require(msg.sender == newOwner, 'denied-new-owner');
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
  function Exists(address recordId) external returns(bool);
  function GetById(address recordId) external returns(uint256,IScheduleIII.Data memory);
}

contract dtable is owned {

  event Inserted(address _sender, address _recordId);
  event Updated(address _sender, address _recordId);
  event Deleted(address _sender, address _recordId);

  struct Data {
    address A_Wallet;
    address A_ScheduleIII_Pointer;
  }
  struct Record {
    Data data;
    uint idListPointer;
  }

  mapping(address => Record) public Table;
  address[] public IdList;
  string public Name = "ViewII";

  function Exists(address recordId) public view returns(bool exists) {
    if (IdList.length == 0) return false;
    return (IdList[Table[recordId].idListPointer] == recordId);
  }

  function GetLength() public view returns(uint count) {
    return IdList.length;
  }

  function GetByIndex(uint recordIndex) public returns(address recordId, Data memory record ,IScheduleIII.Data memory R_ScheduleIII_Data) {
    require(recordIndex < IdList.length, 'recordIndex-out-of-range');
        IScheduleIII A_ScheduleIII_Pointer_pointerInstance = IScheduleIII(0xd1731B97F15b69f5b6d673eFD249D87c467D02B0);
        IScheduleIII.Data memory ScheduleIII_Data;
        uint A_ScheduleIII_Pointer_index;
        (A_ScheduleIII_Pointer_index, ScheduleIII_Data) = A_ScheduleIII_Pointer_pointerInstance.GetById(Table[IdList[recordIndex]].data.A_ScheduleIII_Pointer);
      return (IdList[recordIndex], Table[IdList[recordIndex]].data, ScheduleIII_Data);
  }

  function GetById(address recordId) public returns(uint index, Data memory record ,IScheduleIII.Data memory R_ScheduleIII_Data) {
    require(Exists(recordId), 'recordId-not-found');
        IScheduleIII A_ScheduleIII_Pointer_pointerInstance = IScheduleIII(0xd1731B97F15b69f5b6d673eFD249D87c467D02B0);
        IScheduleIII.Data memory ScheduleIII_Data;
        uint A_ScheduleIII_Pointer_index;
        (A_ScheduleIII_Pointer_index, ScheduleIII_Data) = A_ScheduleIII_Pointer_pointerInstance.GetById(Table[recordId].data.A_ScheduleIII_Pointer);
      return (Table[recordId].idListPointer, Table[recordId].data, ScheduleIII_Data);
  }

  function Insert(Data memory recordData) public authorized returns(bool success) {
    address recordAddress = address(uint160(uint(keccak256(abi.encodePacked(msg.sender, IdList.length, block.timestamp)))));
    require(!Exists(recordAddress), 'recordId-already-exist');
    IScheduleIII A_ScheduleIII_Pointer_pointerInstance = IScheduleIII(0xd1731B97F15b69f5b6d673eFD249D87c467D02B0);
    require(A_ScheduleIII_Pointer_pointerInstance.Exists(recordData.A_ScheduleIII_Pointer), 'pointer-record-address-not-found');
    Table[recordAddress].data = recordData;
    IdList.push(recordAddress);
    Table[recordAddress].idListPointer = IdList.length - 1;
    emit Inserted(msg.sender, recordAddress);
    return true;
  }

  function Update(address recordId, Data memory recordData) public authorized returns(bool success) {
    require(Exists(recordId), 'recordId-not-found');
    IScheduleIII A_ScheduleIII_Pointer_pointerInstance = IScheduleIII(0xd1731B97F15b69f5b6d673eFD249D87c467D02B0);
    require(A_ScheduleIII_Pointer_pointerInstance.Exists(recordData.A_ScheduleIII_Pointer), 'pointer-record-address-not-found');
    Table[recordId].data = recordData;
    emit Updated(msg.sender, recordId);
    return true;
  }

  function Delete(address recordId) public authorized returns(bool success) {
    require(Exists(recordId), 'recordId-not-found');
    uint recordIdListPointerToDelete = Table[recordId].idListPointer;
    address recordIdListPointerToKeep = IdList[IdList.length - 1];
    IdList[recordIdListPointerToDelete] = recordIdListPointerToKeep;
    Table[recordIdListPointerToKeep].idListPointer = recordIdListPointerToDelete;
    IdList.pop();
    emit Deleted(msg.sender, recordId);
    return true;
  }

}
