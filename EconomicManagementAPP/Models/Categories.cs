using System.ComponentModel.DataAnnotations;

namespace EconomicManagementAPP.Models
{
    public class Categories
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "{0} is required")]
        [StringLength(maximumLength: 50, ErrorMessage = "Name cannot be longer than {1} characters")]
        [Display(Name = "Nombre")]
        public string Name { get; set; }

        [Required(ErrorMessage = "{0} is required")]
        [Display(Name = "Tipo de Operación")]
        public OperationTypes OperationTypeId { get; set; }

        [Display(Name = "Id de Usuario")]
        [Required(ErrorMessage = "{0} is required")]
        public int UserId { get; set; }
    }
}
