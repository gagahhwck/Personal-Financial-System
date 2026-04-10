using System.ComponentModel.DataAnnotations;

namespace PersonalFinanceTracker.Models.ViewModels
{
    public class AddTransactionViewModel
    {
        [Required]
        [Range(0.01, double.MaxValue, ErrorMessage = "Amount must be greater than 0")]
        public decimal Amount { get; set; }

        [Required(ErrorMessage = "Description is required")]
        public string? Description { get; set; }

        [Required]
        public DateTime TransactionDate { get; set; }

        [Required]
        public int TransactionType { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "Please select a category")]
        public int CategoryId { get; set; }
        
        // Category lists
        public List<CategoryModel> ExpenseCategories { get; set; } = new List<CategoryModel>();
        public List<CategoryModel> IncomeCategories { get; set; } = new List<CategoryModel>();
    }
}