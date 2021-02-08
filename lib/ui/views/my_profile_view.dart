import 'package:barber_app_client/core/viewmodels/my_profile_viewmodel.dart';
import 'package:barber_app_client/ui/constants/margins.dart';
import 'package:barber_app_client/ui/constants/ui_helpers.dart';
import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:barber_app_client/ui/widgets/custom_button.dart';
import 'package:barber_app_client/ui/widgets/input_field.dart';
import 'package:barber_app_client/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stacked/stacked.dart';

class MyProfileView extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(3, errorText: 'Name must be at least 3 characters long')
  ]);

  final surnameValidator = MultiValidator([
    RequiredValidator(errorText: 'Surname is required'),
    MinLengthValidator(3,
        errorText: 'Surname must be at least 3 characters long')
  ]);

  final phoneNumberValidator = MultiValidator([
    RequiredValidator(errorText: 'Phone number is required'),
    MinLengthValidator(10, errorText: 'Phone number must be 10 digits long'),
    MaxLengthValidator(10, errorText: 'Phone number must be 10 digits long')
  ]);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyProfileViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundPrimary,
              body: Stack(children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: pageHorizontalMargin,
                      vertical: pageVerticalMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      largeSpace,
                      Text(
                        'Update account',
                        style: headerTextFont,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            mediumSpace,
                            model.initialised
                                ? Column(
                                    children: [
                                      customInputField(
                                          fieldTitle: 'Name',
                                          controller: nameController,
                                          validator: nameValidator),
                                      customInputField(
                                          fieldTitle: 'Surname',
                                          controller: surnameController,
                                          validator: surnameValidator,
                                          inputType:
                                              TextInputType.streetAddress),
                                      customInputField(
                                          fieldTitle: 'Phone Number',
                                          controller: phoneNumberController,
                                          validator: phoneNumberValidator,
                                          inputType: TextInputType.phone),
                                    ],
                                  )
                                : Text(''),
                            customButton('Update profile', () {
                              if (_formKey.currentState.validate()) {
                                model.updateProfile(
                                    surname: surnameController.text,
                                    name: nameController.text,
                                    phoneNo: phoneNumberController.text);
                              }
                            })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                loadingIndicator(
                    model.isBusy,
                    model.initialised
                        ? 'Updating profile..'
                        : 'Fetching your profile..')
              ]),
            ),
        onModelReady: (model) async {
          await model.initialise();
          nameController = TextEditingController(text: model.user.name);
          surnameController = TextEditingController(text: model.user.surname);
          phoneNumberController =
              TextEditingController(text: model.user.phoneNo);
        },
        viewModelBuilder: () => MyProfileViewModel());
  }
}
