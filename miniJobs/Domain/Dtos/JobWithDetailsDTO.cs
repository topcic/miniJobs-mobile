public class JobWithDetails
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public string StreetAddressAndNumber { get; set; }
    public DateTime? ApplicationsEndTo { get; set; }
    public int State { get; set; }
    public int? Wage { get; set; }
    public int CityId { get; set; }
    public int Status { get; set; }
    public DateTime Created { get; set; }
    public int? CreatedBy { get; set; }
    public DateTime? LastModified { get; set; }
    public int? LastModifiedBy { get; set; }
    public string? Schedules { get; set; }
    public string? PaymentQuestion { get; set; }
    public string? AdditionalPaymentOptions { get; set; }
}
