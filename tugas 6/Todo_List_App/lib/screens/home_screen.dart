import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import 'add_edit_todo_screen.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load todos when screen opens
    Future.microtask(
          () => Provider.of<TodoProvider>(context, listen: false).loadTodos(),
    );
  }

  void _showFilterDialog() {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Todos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption(
              'All',
              TodoFilter.all,
              todoProvider.currentFilter,
              todoProvider,
            ),
            _buildFilterOption(
              'Completed',
              TodoFilter.completed,
              todoProvider.currentFilter,
              todoProvider,
            ),
            _buildFilterOption(
              'Incomplete',
              TodoFilter.incomplete,
              todoProvider.currentFilter,
              todoProvider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
      String label,
      TodoFilter filter,
      TodoFilter currentFilter,
      TodoProvider provider,
      ) {
    return RadioListTile<TodoFilter>(
      title: Text(label),
      value: filter,
      groupValue: currentFilter,
      onChanged: (value) {
        if (value != null) {
          provider.setFilter(value);
          Navigator.pop(context);
        }
      },
    );
  }

  void _showDeleteDialog(String id, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TodoProvider>(context, listen: false).deleteTodo(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Todo deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearCompletedDialog() {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    if (todoProvider.completedCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No completed todos to clear')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Completed'),
        content: Text(
          'Are you sure you want to delete ${todoProvider.completedCount} completed todo(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              todoProvider.clearCompleted();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Completed todos cleared')),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear Completed'),
              ),
            ],
            onSelected: (value) {
              if (value == 'clear') {
                _showClearCompletedDialog();
              }
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          if (todoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final todos = todoProvider.todos;

          return Column(
            children: [
              // Stats Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Total',
                      todoProvider.totalCount.toString(),
                      Icons.list,
                    ),
                    _buildStatItem(
                      'Completed',
                      todoProvider.completedCount.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                    _buildStatItem(
                      'Pending',
                      todoProvider.incompleteCount.toString(),
                      Icons.pending,
                      Colors.orange,
                    ),
                  ],
                ),
              ),

              // Filter Chip
              if (todoProvider.currentFilter != TodoFilter.all)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Chip(
                    label: Text(
                      'Filter: ${_getFilterName(todoProvider.currentFilter)}',
                    ),
                    onDeleted: () => todoProvider.setFilter(TodoFilter.all),
                  ),
                ),

              // Todo List
              Expanded(
                child: todos.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getEmptyMessage(todoProvider.currentFilter),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return TodoItem(
                      todo: todo,
                      onToggle: () => todoProvider.toggleTodoStatus(todo.id),
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditTodoScreen(todo: todo),
                          ),
                        );
                      },
                      onDelete: () => _showDeleteDialog(todo.id, todo.title),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditTodoScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Todo'),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, [Color? color]) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.blue, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _getFilterName(TodoFilter filter) {
    switch (filter) {
      case TodoFilter.completed:
        return 'Completed';
      case TodoFilter.incomplete:
        return 'Incomplete';
      case TodoFilter.all:
      default:
        return 'All';
    }
  }

  String _getEmptyMessage(TodoFilter filter) {
    switch (filter) {
      case TodoFilter.completed:
        return 'No completed todos yet';
      case TodoFilter.incomplete:
        return 'No pending todos';
      case TodoFilter.all:
      default:
        return 'No todos yet. Add one!';
    }
  }
}