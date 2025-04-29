import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder/di/dependency_injection.dart';
import 'package:kinder/domain/cubits/liked_cats_cubit.dart';

class LikedCatsScreen extends StatelessWidget {
  const LikedCatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LikedCatsCubit>()..loadLikedCats(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Liked Cats'),
          backgroundColor: Colors.indigo,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
                onChanged:
                    (query) => context.read<LikedCatsCubit>().filterCats(query),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BlocBuilder<LikedCatsCubit, LikedCatsState>(
                builder: (context, state) {
                  final breeds =
                      state.likedCats.map((cat) => cat.breed).toSet().toList()
                        ..sort();
                  return DropdownButton<String?>(
                    isExpanded: true,
                    hint: const Text('Select Breed'),
                    value: state.selectedBreed,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All Breeds'),
                      ),
                      ...breeds.map(
                        (breed) => DropdownMenuItem<String>(
                          value: breed,
                          child: Text(breed),
                        ),
                      ),
                    ],
                    onChanged:
                        (breed) =>
                            context.read<LikedCatsCubit>().filterByBreed(breed),
                  );
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<LikedCatsCubit, LikedCatsState>(
                builder: (context, state) {
                  if (state.filteredCats.isEmpty) {
                    return const Center(child: Text('No liked cats yet'));
                  }
                  return ListView.builder(
                    itemCount: state.filteredCats.length,
                    itemBuilder: (context, index) {
                      final cat = state.filteredCats[index];
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: cat.url,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) =>
                                  const CircularProgressIndicator(),
                          errorWidget:
                              (context, url, error) => const Icon(Icons.error),
                        ),
                        title: Text(cat.breed),
                        subtitle: Text(
                          cat.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            context.read<LikedCatsCubit>().removeLikedCat(
                              cat.id,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
