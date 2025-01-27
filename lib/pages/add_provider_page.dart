import 'package:feedback/cubits/add_provider_cubit.dart';
import 'package:feedback/cubits/auth_cubit.dart';
import 'package:feedback/helpers/categories.dart';
import 'package:feedback/pages/feedback_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import '../cubits/provider_cubit.dart';
import '../helpers/professions.dart';

class AddProvider extends StatefulWidget {
  const AddProvider({super.key});

  @override
  State<AddProvider> createState() => _AddProviderState();
}

class _AddProviderState extends State<AddProvider> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _onlineHandleController = TextEditingController();
  final TextEditingController _socialHandleController = TextEditingController();
  final List<String> _tags = [];
  final List<String> _onlineHandles = [];
  final List<String> _socialHandles = [];
  double lat = 0.0;
  double long = 0.0;
  bool isLoading = false;

  void addProvider(String userId) {
    setState(() {
      isLoading = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adding Provider'),
          content: const Text('Be sure to provide accurate information as this will be visible to everyone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<AddProviderCubit>().addProvider(
                  _nameController.text,
                  _typeController.text,
                  _descriptionController.text,
                  userId,
                  _tags,
                  _onlineHandles,
                  _socialHandles,
                  lat,
                  long,
                );
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      }
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProviderCubit, AddProviderState>(
  listener: (context1, state) {
    if(state is AddProviderSuccess) {
      ScaffoldMessenger.of(context1).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(state.message),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      context.read<ProviderCubit>().getProviders();
      Future.delayed(const Duration(milliseconds: 500), () {
        _nameController.clear();
        _descriptionController.clear();
        _typeController.clear();
        _tagsController.clear();
        _onlineHandleController.clear();
        _socialHandleController.clear();
        _tags.clear();
        _onlineHandles.clear();
        _socialHandles.clear();
        long = 0.0;
        lat = 0.0;
        context.pop();
      });
    }
    else if(state is AddProviderFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(state.error),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  },
  builder: (context, state) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const FeedbackAppbar(),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.3,
                right: MediaQuery.of(context).size.width * 0.3,
                top: 50,
                bottom: 50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create New Provider',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Name',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(bottom: 10, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        hintText: 'Name',
                        hintStyle:
                        TextStyle(color: Colors.black54, fontSize: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Type',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(bottom: 10, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    child: TypeAheadField(
                      controller: _typeController,
                      itemBuilder: (context, String suggestion) {
                        return ListTile(
                          title: Text(suggestion),
                        );
                      },
                      onSelected: (String value) => _typeController.text = value,
                      suggestionsCallback: (String search) {
                        return CategoryService.getSuggestions(search);
                      },
                      builder: (context, controller, focusNode) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: 'Type of service they provide',
                            hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                            border: InputBorder.none,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    child: TextFormField(
                      maxLines: 3,
                      controller: _descriptionController,
                      style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        hintText: 'Description',
                        hintStyle:
                        TextStyle(color: Colors.black54, fontSize: 15),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tags',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 200,
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                        ),
                        child: TextFormField(
                          controller: _tagsController,
                          style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: 'Related tags',
                            hintStyle:
                            TextStyle(color: Colors.black54, fontSize: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _tags.add(_tagsController.text);
                            _tagsController.clear();
                          });
                        },
                        icon: const Icon(Icons.add_circle_rounded),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    children: _tags.map((tag) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tag,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _tags.remove(tag);
                                    });
                                  },
                                  icon: const Icon(Icons.close, color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Online Handles',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 200,
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                        ),
                        child: TextFormField(
                          controller: _onlineHandleController,
                          style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: 'Website, Email, etc',
                            hintStyle:
                            TextStyle(color: Colors.black54, fontSize: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _onlineHandles.add(_onlineHandleController.text);
                            _onlineHandleController.clear();
                          });
                        },
                        icon: const Icon(Icons.add_circle_rounded),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    children: _onlineHandles.map((tag) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tag,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _onlineHandles.remove(tag);
                                    });
                                  },
                                  icon: const Icon(Icons.close, color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Social Handles',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        width: 200,
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                        ),
                        child: TextFormField(
                          controller: _socialHandleController,
                          style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: 'Social Media Handles',
                            hintStyle:
                            TextStyle(color: Colors.black54, fontSize: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _socialHandles.add(_socialHandleController.text);
                            _socialHandleController.clear();
                          });
                        },
                        icon: const Icon(Icons.add_circle_rounded),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    children: _socialHandles.map((tag) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 50,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tag,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _socialHandles.remove(tag);
                                    });
                                  },
                                  icon: const Icon(Icons.close, color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Location:',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                        ),
                        child: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: OpenStreetMapSearchAndPick(
                                        onPicked: (location) {
                                          setState(() {
                                            long = location.latLong.longitude;
                                            lat = location.latLong.latitude;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  );
                                }
                            );
                          },
                          child: Text(
                            long == 0.0 && lat == 0.0
                                ? 'Pick Location'
                                : '${long.toStringAsFixed(2)}, ${lat.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text('[Your location is private and will not be shared with anyone. We collect location just to show your providers nearby]', style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 30,),
                  BlocBuilder<AuthCubit, LoginState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if(state is LoginSuccess) {
                            addProvider(state.user.id);
                          }
                        },
                        style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all<Size>(
                              const Size(200, 50)),
                          backgroundColor:
                          WidgetStateProperty.all<Color>(
                              Theme.of(context).colorScheme.primary),
                          padding: WidgetStateProperty.all<
                              EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 10)),
                          shape: WidgetStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: isLoading
                            ? const FittedBox(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : FittedBox(
                          child: Text(
                            'Add Provider',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium,
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  },
);
  }
}
