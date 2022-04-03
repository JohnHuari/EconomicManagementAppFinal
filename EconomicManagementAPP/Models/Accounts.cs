using EconomicManagementAPP.Validations;
using System.ComponentModel.DataAnnotations;

namespace EconomicManagementAPP.Models
{
    public class Accounts
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "{0} is required")]
        [Display(Name ="Nombre")]
        public string Name { get; set; }

        [Required(ErrorMessage = "{0} is required")]
        [Display(Name = "Tipo de Cuenta")]
        public int AccountTypeId { get; set; }

        [Required(ErrorMessage = "{0} is required")]
        public decimal Balance { get; set; }

        [Required(ErrorMessage = "{0} is required")]
        [Display(Name = "Descripción")]
        public string Description { get; set; }
    }
}
