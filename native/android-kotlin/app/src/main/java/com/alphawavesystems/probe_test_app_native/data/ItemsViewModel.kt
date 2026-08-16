package com.alphawavesystems.probe_test_app_native.data

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel

data class Item(
    val id: Int,
    val title: String,
    val description: String,
)

/// Twin of the Flutter app's ItemProvider: 50 generated items, live
/// case-insensitive title search, and delete (driven by swipe-to-dismiss).
class ItemsViewModel : ViewModel() {
    private val allItems = (0 until 50)
        .map { Item(id = it, title = "Item $it", description = "Description for item $it") }
        .toMutableList()

    var searchQuery by mutableStateOf("")
        private set
    var items by mutableStateOf<List<Item>>(allItems.toList())
        private set

    fun search(query: String) {
        searchQuery = query
        applySearch()
    }

    fun deleteItem(id: Int) {
        allItems.removeAll { it.id == id }
        applySearch()
    }

    private fun applySearch() {
        items = if (searchQuery.isEmpty()) {
            allItems.toList()
        } else {
            allItems.filter { it.title.contains(searchQuery, ignoreCase = true) }
        }
    }
}
