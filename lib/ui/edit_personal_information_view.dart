import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unitime/core/constants/app_spacing.dart';
import 'package:unitime/data/user.dart';
import 'package:unitime/providers/session_provider.dart';

class EditPersonalInformationView extends StatefulWidget {
  const EditPersonalInformationView({super.key});

  @override
  State<EditPersonalInformationView> createState() =>
      _EditPersonalInformationViewState();
}

class _EditPersonalInformationViewState
    extends State<EditPersonalInformationView> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailNameController;
  late TextEditingController _promotionNameController;
  late TextEditingController _groupNameController;

  final bool _enableEdit = false;
  late final ValueNotifier<bool> _isEnabled;
  late final ValueNotifier<String> _editedFirstName;
  late final ValueNotifier<String> _editedLastName;
  late final GlobalKey<FormState> _formKey;

  @override
  initState() {
    super.initState();

    _formKey = GlobalKey<FormState>();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailNameController = TextEditingController();
    _promotionNameController = TextEditingController();
    _groupNameController = TextEditingController();

    _isEnabled = ValueNotifier<bool>(false);
    _editedFirstName = ValueNotifier<String>('');
    _editedLastName = ValueNotifier<String>('');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailNameController.dispose();
    _promotionNameController.dispose();
    _groupNameController.dispose();
    _isEnabled.dispose();
    _editedFirstName.dispose();
    _editedLastName.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = context.watch<SessionProvider>().currentUser;
    _firstNameController.text = user!.firstName;
    _lastNameController.text = user.lastName;
    _emailNameController.text = user.email;
    _promotionNameController.text =
        user.promotion?.name ?? "No promotion";

    _groupNameController.text =
        user.group?.name ?? "No group";

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            color: Theme.of(context).colorScheme.onSecondary,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("Settings", style: Theme.of(context).textTheme.bodyLarge),
        ),
        body: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Personal infos",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),

                    IconButton(
                      onPressed: () {
                        _isEnabled.value = true;
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TAppSpacing.lg),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "First name :",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: TAppSpacing.sm),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isEnabled,

                        builder: (context, bool isEnabled, child) {
                          return TextFormField(
                            enabled: isEnabled,
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                            ),

                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a valid first name";
                              }
                              return null;
                            },

                            onChanged: (String value) {
                              _editedFirstName.value = value;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: TAppSpacing.md),
                      Text(
                        "Last Name :",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: TAppSpacing.sm),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isEnabled,
                        builder: (BuildContext context, bool isEnabled, child) {
                          return TextFormField(
                            enabled: isEnabled,
                            controller: _lastNameController,

                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                            ),

                            onChanged: (String value) {
                              _editedLastName.value = value;
                            },
                          );
                        },
                      ),

                      const SizedBox(height: TAppSpacing.md),
                      Text(
                        "Email :",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: TAppSpacing.sm),
                      TextFormField(
                        enabled: false,
                        controller: _emailNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainer,
                        ),
                      ),
                      const SizedBox(height: TAppSpacing.md),
                      Text(
                        "Promotion :",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: TAppSpacing.sm),
                      Stack(
                        alignment: AlignmentGeometry.centerRight,
                        children: [
                          TextFormField(
                            enabled: _enableEdit,
                            controller: _promotionNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                            ),
                          ),
                          IconButton(onPressed: () {}, icon: Icon(Icons.link)),
                        ],
                      ),
                      const SizedBox(height: TAppSpacing.md),
                      Text(
                        "Group :",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: TAppSpacing.sm),
                      Stack(
                        alignment: AlignmentGeometry.centerRight,
                        children: [
                          TextFormField(
                            enabled: _enableEdit,
                            controller: _groupNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                            ),
                          ),
                          IconButton(onPressed: () {}, icon: Icon(Icons.link)),
                        ],
                      ),
                      const SizedBox(height: TAppSpacing.lg),

                      ValueListenableBuilder(
                        valueListenable: _isEnabled,
                        builder: (context, bool isEnabled, child) {
                          return Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ElevatedButton(
                                style: ButtonStyle(),
                                onPressed: _isEnabled.value
                                    ? _submitForm
                                    : null,
                                child: Text("Submit"),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
