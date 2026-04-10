// wwwroot/js/dashboard.js

// Runs when the page loads
document.addEventListener('DOMContentLoaded', function () {
    // AJAX calls removed
    console.log('Dashboard loaded');
});

// Open quick add transaction modal
function quickAdd(type, category, categoryName) {
    document.getElementById('quick-type').value = type;
    document.getElementById('quick-category').value = category;
    document.getElementById('quick-category-display').textContent = categoryName;

    const modalTitle = document.getElementById('quick-modal-title');
    const icon = type === 'income' ? 'fa-arrow-up' : 'fa-arrow-down';
    const color = type === 'income' ? 'text-success' : 'text-danger';
    modalTitle.innerHTML = `<i class="fas ${icon} ${color} me-2"></i>${categoryName} ${type === 'income' ? 'Income' : 'Expense'}`;

    // Clear the form
    document.getElementById('quick-amount').value = '';
    document.getElementById('quick-description').value = '';

    // Open the modal
    const modal = new bootstrap.Modal(document.getElementById('quickAddModal'));
    modal.show();

    // Amount input focus
    setTimeout(() => {
        document.getElementById('quick-amount').focus();
    }, 500);
}

// Save quick transaction - AJAX removed
async function saveQuickTransaction() {
    const amount = document.getElementById('quick-amount').value;
    const description = document.getElementById('quick-description').value;

    // Validation
    if (!amount || amount <= 0) {
        alert('Please enter a valid amount');
        return;
    }

    // Close the modal
    const modal = bootstrap.Modal.getInstance(document.getElementById('quickAddModal'));
    modal.hide();

    // Redirect to Transaction/Add page
    window.location.href = '/Transaction/Add';
}

// Delete transaction - AJAX removed  
function deleteTransaction(transactionId) {
    if (confirm('Are you sure you want to delete this transaction?')) {
        // Form submit to delete
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = `/Transaction/Delete/${transactionId}`;
        
        const methodInput = document.createElement('input');
        methodInput.type = 'hidden';
        methodInput.name = '_method';
        methodInput.value = 'DELETE';
        form.appendChild(methodInput);

        const tokenInput = document.createElement('input');
        tokenInput.type = 'hidden';
        tokenInput.name = '__RequestVerificationToken';
        tokenInput.value = getAntiForgeryToken();
        form.appendChild(tokenInput);

        document.body.appendChild(form);
        form.submit();
    }
}

// Currency format
function formatCurrency(amount) {
    return new Intl.NumberFormat('de-DE', {
        style: 'currency',
        currency: 'EUR'
    }).format(amount || 0);
}

// Date format
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('de-DE', {
        day: '2-digit',
        month: 'short'
    });
}

// Get anti-forgery token
function getAntiForgeryToken() {
    return document.querySelector('input[name="__RequestVerificationToken"]')?.value || '';
}

// Show toast notification - simplified
function showToast(message, type = 'success') {
    alert(message);
}