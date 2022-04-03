using Microsoft.AspNetCore.Mvc.Rendering;

namespace EconomicManagementAPP.Models
{
    public class AccountCreateViewModel:Accounts
    {
        public IEnumerable<SelectListItem> AccountTypes { get; set; }
    }
}
