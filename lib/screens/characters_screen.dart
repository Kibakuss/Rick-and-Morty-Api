import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../model/character_model.dart';
import 'character_detail.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
   int pageNumber = 1;
  final RefreshController refreshController = RefreshController();
  bool _isPagination = false;
  @override
  void initState() {
    super.initState();
    pageNumber = 1;
    futureCharacter = fetchCharacter();
  }

  Future<List<Results>> fetchCharacter() async {
    final response = await http.get(Uri.parse(
        'https://rickandmortyapi.com/api/character/?page=$pageNumber'));
    pageNumber++;

    if (response.statusCode == 200) {
      var character = Character.fromJson(jsonDecode(response.body));
      return character.results.toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }

  late Future<List<Results>> futureCharacter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        title: const Text(
          'The Rick and Morty API',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body:
         FutureBuilder<List<Results>>(
          future: futureCharacter,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final character = snapshot.data!;

              return  SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: false,
        onLoading: () {
          _isPagination = true;
          pageNumber++;
        },
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: character.length,
                  itemExtent: 150,
                  itemBuilder: (BuildContext context, int index) {
                    // final  results = Results.fromJson();
              
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Stack(
                        children: [
                          Container(
                            width: (MediaQuery.of(context).size.width),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade600,
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.2)),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ]),
                            clipBehavior: Clip.hardEdge,
                            child: Row(
                              children: [
                                Image.network(character[index].image),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 7),
                                      Text(
                                        character[index].name,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                                color: character[index].status ==
                                                        'Dead'
                                                    ? Colors.redAccent
                                                    : character[index].status ==
                                                            'Unknown'
                                                        ? Colors.grey.shade300
                                                        : const Color.fromARGB(
                                                            255, 136, 255, 0),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                  text: character[index].status,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const TextSpan(
                                                  text: ' - ',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: character[index].species,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ]),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        'Origin:',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        character[index].location['name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 7),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CharacterDetail(
                                          characterData: character[index])),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const Text('test');
          },
        ),
      
    );
  }
}
