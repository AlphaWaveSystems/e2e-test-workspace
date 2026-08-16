package com.alphawavesystems.probe_test_app_native.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.ListItem
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.SwipeToDismissBox
import androidx.compose.material3.SwipeToDismissBoxValue
import androidx.compose.material3.Text
import androidx.compose.material3.rememberSwipeToDismissBoxState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.alphawavesystems.probe_test_app_native.data.Item
import com.alphawavesystems.probe_test_app_native.data.ItemsViewModel
import kotlinx.coroutines.launch

/// Twin of the Flutter app's ItemListPage: searchable 50-item list with
/// swipe-to-dismiss delete, empty state, and an add FAB.
@Composable
fun ItemListScreen(navController: NavController, itemsViewModel: ItemsViewModel) {
    val snackbarHostState = remember { SnackbarHostState() }
    val scope = rememberCoroutineScope()

    ScreenScaffold(
        title = "Items",
        navController = navController,
        snackbarHostState = snackbarHostState,
        floatingActionButton = {
            FloatingActionButton(
                onClick = {
                    scope.launch { snackbarHostState.showSnackbar("Add item tapped") }
                },
                modifier = Modifier.testTag("fab_add"),
            ) {
                Icon(Icons.Filled.Add, contentDescription = "Add")
            }
        },
    ) { padding ->
        Column(Modifier.padding(padding).fillMaxSize()) {
            OutlinedTextField(
                value = itemsViewModel.searchQuery,
                onValueChange = itemsViewModel::search,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
                    .testTag("search_field"),
                placeholder = { Text("Search items...") },
                leadingIcon = { Icon(Icons.Filled.Search, contentDescription = null) },
                singleLine = true,
            )
            if (itemsViewModel.items.isEmpty()) {
                Box(Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    Text(
                        "No items found",
                        modifier = Modifier.testTag("empty_state"),
                        style = MaterialTheme.typography.titleMedium,
                    )
                }
            } else {
                LazyColumn(
                    modifier = Modifier
                        .fillMaxSize()
                        .testTag("scrollable_list"),
                ) {
                    items(itemsViewModel.items, key = { it.id }) { item ->
                        DismissibleItemRow(
                            item = item,
                            index = itemsViewModel.items.indexOf(item),
                            onDelete = { itemsViewModel.deleteItem(item.id) },
                        )
                    }
                }
            }
        }
    }
}

@Composable
private fun DismissibleItemRow(item: Item, index: Int, onDelete: () -> Unit) {
    val dismissState = rememberSwipeToDismissBoxState(
        confirmValueChange = { value ->
            if (value == SwipeToDismissBoxValue.EndToStart) {
                onDelete()
                true
            } else {
                false
            }
        },
    )

    SwipeToDismissBox(
        state = dismissState,
        modifier = Modifier.testTag("dismissible_${item.id}"),
        enableDismissFromStartToEnd = false,
        backgroundContent = {
            Box(
                Modifier
                    .fillMaxSize()
                    .background(Color.Red)
                    .padding(end = 16.dp),
                contentAlignment = Alignment.CenterEnd,
            ) {
                Icon(Icons.Filled.Delete, contentDescription = null, tint = Color.White)
            }
        },
    ) {
        ListItem(
            modifier = Modifier.testTag("list_item_$index"),
            leadingContent = { Text("${item.id}") },
            headlineContent = { Text(item.title) },
            supportingContent = { Text(item.description) },
        )
    }
}
