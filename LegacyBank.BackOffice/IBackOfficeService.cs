using System.Data;
using System.ServiceModel;

namespace LegacyBank.BackOffice
{
    [ServiceContract]
    public interface IBackOfficeService
    {
        [OperationContract]
        DataSet PostPayment(int customerId, decimal amount, string currency, string reference);

        [OperationContract]
        DataSet GetCustomerBalance(int customerId);
    }
}
