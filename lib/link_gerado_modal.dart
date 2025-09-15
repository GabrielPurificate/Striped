import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class LinkGeradoModal extends StatelessWidget {
  final String link;

  const LinkGeradoModal({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 32,
          bottom: 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black54, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pronto! Lista compartilhada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Image.network(
                'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=$link',
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ou compartilhe o link:',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      link,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black45,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.copy,
                      size: 22,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: link));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copiado!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF34D399),
                mini: false,
                onPressed: () {
                  final textoCompartilhar = 'Use este código para entrar na minha lista no app Striped Lists: $link';
            
                  Share.share(textoCompartilhar);
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.share, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
