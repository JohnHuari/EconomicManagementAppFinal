using System.ComponentModel.DataAnnotations;

namespace EconomicManagementAPP.Models
{
    public class Transactions
    {
        public int Id { get; set; }

        public int UserId { get; set; }

        [Display(Name = "Fecha de Transacción")]
        [DataType(DataType.Date)]
        public DateTime TransactionDate { get; set; } = DateTime.Today;

        [Required(ErrorMessage = "{0} is required")]
        public decimal Total { get; set; }

        [StringLength(maximumLength: 1000, ErrorMessage = "La descripción no puede tener mas de 100 caracteres")]
        public string Description { get; set; }

        [Range(1, maximum: int.MaxValue, ErrorMessage = "Debes seleccionar una de Cuenta")]
        [Display(Name = "Cuenta")]
        public int AccountId { get; set; }

        [Range(1, maximum: int.MaxValue, ErrorMessage = "Debes seleccionar una categoria")]
        [Display(Name = "Categoria")]
        public int CategoryId { get; set; }

        [Display(Name = "Tipo de Operación")]
        public OperationTypes OperationTypesId { get; set; } = OperationTypes.Ingreso;
    }
}
