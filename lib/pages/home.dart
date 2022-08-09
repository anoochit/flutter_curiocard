import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:curiocard_browser/models/card.dart';
import 'package:curiocard_browser/services/query.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Curio Cards"),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getAllCards),
          pollInterval: const Duration(seconds: 0),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Text("Error cannot load data!");
          }

          // is loading
          if (result.isLoading) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                Text("Loading..."),
              ],
            ));
          }

          // is empty
          if (result.data == null) {
            return const Text('No data');
          }

          final data = result.data;
          final jsonString = json.encode(data);
          final curioCard = curioCardFromJson(jsonString);

          //log('data = ${jsonString}');

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.78),
            itemCount: curioCard.cardTypes.length,
            itemBuilder: (context, index) {
              log('https://ipfs.io/ipfs/${curioCard.cardTypes[index].ipfsHash}');
              return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: CachedNetworkImage(
                  fit: BoxFit.fitWidth,
                  imageUrl: 'https://ipfs.io/ipfs/${curioCard.cardTypes[index].ipfsHash}',
                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
