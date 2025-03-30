import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinder/di/dependency_injection.dart';
import 'package:kinder/domain/cubits/liked_cats_cubit.dart';
import 'package:kinder/domain/cubits/liked_cats_state.dart';

class LikedCatsScreen extends StatelessWidget {
  const LikedCatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LikedCatsCubit>()..loadLikedCats(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Liked Cats')),
        body: BlocBuilder<LikedCatsCubit, LikedCatsState>(
          builder: (context, state) {
            final uniqueBreeds =
                state.likedCats.map((cat) => cat.breed).toSet().toList();

            return Column(
              children: [
                if (uniqueBreeds.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String?>(
                      value: state.selectedBreed,
                      hint: const Text('Filter by breed'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All')),
                        ...uniqueBreeds.map(
                          (breed) => DropdownMenuItem(
                            value: breed,
                            child: Text(breed),
                          ),
                        ),
                      ],
                      onChanged:
                          (value) => context
                              .read<LikedCatsCubit>()
                              .filterByBreed(value),
                    ),
                  ),
                Expanded(
                  child:
                      state.filteredCats.isEmpty
                          ? const Center(child: Text('No liked cats yet'))
                          : ListView.builder(
                            itemCount: state.filteredCats.length,
                            itemBuilder: (context, index) {
                              final cat = state.filteredCats[index];
                              return ListTile(
                                leading: Image.network(
                                  cat.url,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(cat.breed),
                                subtitle: Text(
                                  'Liked on: ${cat.likedAt.toLocal().toString().split('.')[0]}',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => context
                                          .read<LikedCatsCubit>()
                                          .removeLikedCat(cat.id),
                                ),
                              );
                            },
                          ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
