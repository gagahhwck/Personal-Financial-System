// wwwroot/js/transaction-add.js

document.addEventListener('DOMContentLoaded', function() {
    // Bugünkü tarih set et
    document.getElementById('date').value = new Date().toISOString().split('T')[0];
    
    // İşlem tipi değiştiğinde kategorileri güncelle
    setupTransactionTypeListeners();
    
    // js den alınacaksa burada method var buna bakarsın..
    // setupFormSubmission();
    
    // Son işlemleri yükle
    loadRecentTransactionsPreview();
    
    // Amount input'a focus
    document.getElementById('amount').focus();
});

// İşlem tipi radio butonlarını dinle
function setupTransactionTypeListeners() {
    const expenseRadio = document.getElementById('expenseRadio');
    const incomeRadio = document.getElementById('incomeRadio');
    const expenseCategories = document.getElementById('expense-categories');
    const incomeCategories = document.getElementById('income-categories');
    const categorySelect = document.getElementById('category');
    
    expenseRadio.addEventListener('change', function() {
        if (this.checked) {
            expenseCategories.style.display = 'block';
            incomeCategories.style.display = 'none';
            categorySelect.value = '';
        }
    });
    
    incomeRadio.addEventListener('change', function() {
        if (this.checked) {
            expenseCategories.style.display = 'none';
            incomeCategories.style.display = 'block';
            categorySelect.value = '';
        }
    });
}

// Form gönderme olayını ayarla
function setupFormSubmission() {
    const form = document.getElementById('addTransactionForm');
    
    form.addEventListener('submit', async function(e) {
        e.preventDefault();
        await saveTransaction(false);
    });
}

// Hızlı tutar butonları
function setAmount(amount) {
    document.getElementById('amount').value = amount;
    document.getElementById('amount').focus();
}

// İşlemi kaydet
async function saveTransaction(addNew = false) {
    const form = document.getElementById('addTransactionForm');
    const saveButton = document.getElementById('saveButton');
    const buttonText = saveButton.querySelector('.button-text');
    const buttonSpinner = saveButton.querySelector('.button-spinner');
    
    // Form verilerini topla
    const formData = {
        amount: parseFloat(document.getElementById('amount').value),
        category: document.getElementById('category').value,
        description: document.getElementById('description').value.trim(),
        type: document.querySelector('input[name="transactionType"]:checked').value,
        date: document.getElementById('date').value
    };
    
    // Validasyon
    if (!validateForm(formData)) {
        return;
    }
    
    // Button loading state
    saveButton.disabled = true;
    buttonText.classList.add('d-none');
    buttonSpinner.classList.remove('d-none');
    
    try {
        const response = await fetch('/Transaction/Add', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'RequestVerificationToken': getAntiForgeryToken()
            },
            body: JSON.stringify(formData)
        });
        
        const result = await response.json();
        
        if (result.success) {
            // Başarılı mesaj
            showToast('İşlem başarıyla eklendi! 🎉', 'success');
            
            if (addNew) {
                // Formu temizle, yeni işlem için hazırla
                resetForm();
                loadRecentTransactionsPreview();
            } else {
                // Dashboard'a yönlendir
                setTimeout(() => {
                    window.location.href = '/Dashboard';
                }, 1000);
            }
        } else {
            showToast(result.message || 'İşlem eklenirken hata oluştu', 'error');
        }
    } catch (error) {
        console.error('İşlem ekleme hatası:', error);
        showToast('Bağlantı hatası oluştu', 'error');
    } finally {
        // Button normal state
        saveButton.disabled = false;
        buttonText.classList.remove('d-none');
        buttonSpinner.classList.add('d-none');
    }
}

// Kaydet ve yeni ekle
async function saveAndAddNew() {
    await saveTransaction(true);
}

// Form validasyonu
function validateForm(formData) {
    // Tutar kontrolü
    if (!formData.amount || formData.amount <= 0) {
        showToast('Lütfen geçerli bir tutar girin', 'error');
        document.getElementById('amount').focus();
        return false;
    }
    
    // Kategori kontrolü
    if (!formData.category) {
        showToast('Lütfen bir kategori seçin', 'error');
        document.getElementById('category').focus();
        return false;
    }
    
    // Açıklama kontrolü
    if (!formData.description) {
        showToast('Lütfen açıklama girin', 'error');
        document.getElementById('description').focus();
        return false;
    }
    
    // Tarih kontrolü
    if (!formData.date) {
        showToast('Lütfen tarih seçin', 'error');
        document.getElementById('date').focus();
        return false;
    }
    
    // Tutar limit kontrolü (opsiyonel)
    if (formData.amount > 1000000) {
        if (!confirm('1.000.000 TL üzerinde bir tutar girdiniz. Devam etmek istediğinizden emin misiniz?')) {
            return false;
        }
    }
    
    return true;
}

// Formu sıfırla
function resetForm() {
    document.getElementById('addTransactionForm').reset();
    document.getElementById('date').value = new Date().toISOString().split('T')[0];
    
    // Gider seçili yap
    document.getElementById('expenseRadio').checked = true;
    document.getElementById('expense-categories').style.display = 'block';
    document.getElementById('income-categories').style.display = 'none';
    
    // Amount'a focus
    setTimeout(() => {
        document.getElementById('amount').focus();
    }, 100);
}

// Son işlemler önizlemesi
async function loadRecentTransactionsPreview() {
    try {
        const response = await fetch('/Transaction/GetRecent?count=3');
        const data = await response.json();
        
        if (data.success) {
            displayRecentTransactionsPreview(data.transactions);
        }
    } catch (error) {
        console.error('Error loading recent transactions:', error);
        document.getElementById('recent-transactions-preview').innerHTML = 
            '<small class="text-muted">Failed to load recent transactions</small>';
    }
}

// Display recent transactions preview
function displayRecentTransactionsPreview(transactions) {
    const container = document.getElementById('recent-transactions-preview');
    
    if (transactions.length === 0) {
        container.innerHTML = '<small class="text-muted">No transactions yet</small>';
        return;
    }
    
    let html = '';
    transactions.forEach(transaction => {
        const isIncome = transaction.type === 'income';
        const amountClass = isIncome ? 'text-success' : 'text-danger';
        const amountPrefix = isIncome ? '+' : '-';
        
        html += `
            <div class="d-flex justify-content-between align-items-center mb-2">
                <div>
                    <small class="fw-bold">${transaction.description}</small>
                    <br>
                    <small class="text-muted">${transaction.category} • ${formatDate(transaction.date)}</small>
                </div>
                <div>
                    <span class="${amountClass} fw-bold">
                        ${amountPrefix}${formatCurrency(transaction.amount)}
                    </span>
                </div>
            </div>
        `;
    });
    
    container.innerHTML = html;
}

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl + Enter = Save
    if (e.ctrlKey && e.key === 'Enter') {
        e.preventDefault();
        saveTransaction(false);
    }
    
    // Ctrl + Shift + Enter = Save and Add New
    if (e.ctrlKey && e.shiftKey && e.key === 'Enter') {
        e.preventDefault();
        saveAndAddNew();
    }
    
    // ESC = Cancel
    if (e.key === 'Escape') {
        window.location.href = '/Dashboard';
    }
});

// Utility functions
function formatCurrency(amount) {
    return new Intl.NumberFormat('de-DE', {
        style: 'currency',
        currency: 'EUR'
    }).format(amount || 0);
}

function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('de-DE', {
        day: '2-digit',
        month: 'short'
    });
}

function getAntiForgeryToken() {
    return document.querySelector('input[name="__RequestVerificationToken"]')?.value || '';
}

function showToast(message, type = 'success') {
    // Use the toast system in the layout
    const toastElement = document.getElementById(type === 'success' ? 'successToast' : 'errorToast');
    const messageElement = document.getElementById(type === 'success' ? 'successMessage' : 'errorMessage');
    
    if (toastElement && messageElement) {
        messageElement.textContent = message;
        const toast = new bootstrap.Toast(toastElement);
        toast.show();
    } else {
        // Fallback alert
        alert(message);
    }
}