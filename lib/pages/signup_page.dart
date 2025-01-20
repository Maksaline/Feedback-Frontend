import 'package:feedback/cubits/sign_up_cubit.dart';
import 'package:feedback/helpers/professions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import '../responsive/responsive_layout.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController username = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController reEnterPass = TextEditingController();
  TextEditingController profession = TextEditingController();
  TextEditingController name = TextEditingController();
  DateTime? dob;
  bool isPassVisible = true;
  bool isRePassVisible = true;
  bool isLoading = false;
  double long = 0.0;
  double lat = 0.0;

  Future<void> _signUp() async {
    if (username.text.isEmpty || pass.text.isEmpty || reEnterPass.text.isEmpty || profession.text.isEmpty || name.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
    } else if (pass.text != reEnterPass.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
    } else {
      setState(() {
        isLoading = true;
      });
      await context.read<SignUpCubit>().signUp(name.text, profession.text, username.text, pass.text, dob!, lat, long);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<SignUpCubit, SignUpState>(
  listener: (context, state) {
    if(state is SignUpSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(state.message),
        ),
      );
      context.go('/login');
    } else if(state is SignUpFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(state.error),
        ),
      );
    }
  },
  builder: (context, state) {
    return Stack(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              height: MediaQuery.of(context).size.height,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: Responsive.isDesktop(context)
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.width,
                    color:
                    Theme.of(context).colorScheme.surface,
                    child: Center(
                      child: SizedBox(
                        width: Responsive.isDesktop(context)
                            ? MediaQuery.of(context).size.width / 3
                            : MediaQuery.of(context).size.width / 1.25,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Responsive.isDesktop(context)
                                  ? const SizedBox()
                                  : Image.asset(
                                'assets/images/logo_text.png',
                                width: MediaQuery.of(context).size.width / 1.8,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign Up',
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                      fontSize: 28,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    'Username',
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Container(
                                    height: 45,
                                    padding: const EdgeInsets.only(top: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                                    ),
                                    child: TextFormField(
                                      controller: username,
                                      style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: 'Username',
                                        hintStyle:
                                        const TextStyle(color: Colors.black54, fontSize: 15),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Password',
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                                    ),
                                    child: TextFormField(
                                      controller: pass,
                                      obscureText: isPassVisible,
                                      style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        hintStyle:
                                        const TextStyle(color: Colors.black54, fontSize: 15),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isPassVisible = !isPassVisible;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.visibility,
                                            color:
                                            Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Text(
                                    'Re-Enter Password',
                                    style: Theme.of(context).textTheme.labelMedium,
                                  ),
                                  Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
                                    ),
                                    child: TextFormField(
                                      controller: reEnterPass,
                                      obscureText: isRePassVisible,
                                      style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        hintStyle:
                                        const TextStyle(color: Colors.black54, fontSize: 15),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isRePassVisible = !isRePassVisible;
                                            });
                                          },
                                          icon: Icon(
                                            Icons.visibility,
                                            color:
                                            Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Your Full Name',
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
                                      controller: name,
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
                                    'Profession',
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
                                      controller: profession,
                                      itemBuilder: (context, String suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      onSelected: (String value) => profession.text = value,
                                      suggestionsCallback: (String search) {
                                        return ProfessionService.getSuggestions(search);
                                      },
                                      builder: (context, controller, focusNode) {
                                        return TextField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                          decoration: const InputDecoration(
                                            hintText: 'Profession',
                                            hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                                            border: InputBorder.none,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        'Date of Birth:',
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
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                            ).then((value) {
                                              setState(() {
                                                dob = value;
                                              });
                                            });
                                          },
                                          child: Text(
                                            dob == null
                                                ? 'Select Date'
                                                : '${dob!.day}/${dob!.month}/${dob!.year}',
                                            style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
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
                                  ElevatedButton(
                                    onPressed: () {
                                      _signUp();
                                    },
                                    style: ButtonStyle(
                                      fixedSize: WidgetStateProperty.all<Size>(
                                          const Size(800, 48)),
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
                                        'Sign Up',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Responsive.isMobile(context)
                      ? const SizedBox()
                      : SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: MediaQuery.of(context).size.width / 4,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        );
  },
),
      )
    );
  }
}
