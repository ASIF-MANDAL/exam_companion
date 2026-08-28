import 'package:flutter/material.dart';

import '../model/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onOpen;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;

  const NoteCard({
    super.key,
    required this.note,
    required this.onOpen,
    required this.onDelete,
    required this.onLongPress,
  });

  Color getCategoryColor() {
    switch (note.category.toLowerCase()) {
      case 'pyq':
        return Colors.orange;
      case 'assignment':
        return Colors.green;
      case 'important':
        return Colors.red;
      case 'notes':
        return Colors.indigo;
      default:
        return Colors.blueGrey;
    }
  }

  IconData getCategoryIcon() {
    switch (note.category.toLowerCase()) {
      case 'pyq':
        return Icons.history_edu;
      case 'assignment':
        return Icons.assignment;
      case 'important':
        return Icons.star;
      case 'notes':
        return Icons.menu_book;
      default:
        return Icons.folder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getCategoryColor();
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onOpen,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 5),
              color: colorScheme.onSurface.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 62,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(width: 14),

            CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              child: Icon(
                getCategoryIcon(),
                color: color,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Sem ${note.semester} • ${note.subject}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colorScheme.onSurface
                          .withOpacity(0.65),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Text(
                      note.category,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.delete_outline,
                color: colorScheme.onSurface
                    .withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}