
abstract class AbstractAuditingEntity {
  String createdBy;
  DateTime createdDate;
  String lastModifiedBy;
  DateTime lastModifiedDate;
  int version;

  AbstractAuditingEntity({
   String createdBy,
   DateTime createdDate,
   String lastModifiedBy,
   DateTime lastModifiedDate,
   int version}
  )
  {
    this.createdBy = createdBy;
    this.createdDate = createdDate;
    this.lastModifiedBy = lastModifiedBy;
    this.lastModifiedDate = lastModifiedDate;
    this.version = version;
  }
}