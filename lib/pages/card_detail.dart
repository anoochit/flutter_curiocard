import 'package:cached_network_image/cached_network_image.dart';
import 'package:curiocard_browser/models/card.dart';
import 'package:flutter/material.dart';

class CardDetailPage extends StatelessWidget {
  const CardDetailPage({Key? key, required this.card}) : super(key: key);

  final CardType card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl: 'https://ipfs.io/ipfs/${card.ipfsHash}',
                progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),

            // title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                card.name,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),

            // description
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                card.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),

            // address
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                card.address,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
