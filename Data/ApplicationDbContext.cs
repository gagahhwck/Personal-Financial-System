using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using PersonalFinancialSystem.Models;

namespace PersonalFinancialSystem.Data
{
    public class ApplicationDbContext : IdentityDbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

        public DbSet<TransactionModel> Transactions { get; set; }
        public DbSet<CategoryModel> Categories { get; set; }
    }
}
