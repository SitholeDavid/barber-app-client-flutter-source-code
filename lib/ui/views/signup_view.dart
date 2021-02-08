import 'package:barber_app_client/core/viewmodels/sign_up_viewmodel.dart';
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

class SignUpView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'email is required'),
    EmailValidator(errorText: 'please enter a valid email address')
  ]);

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(3, errorText: 'Name must be at least 3 characters long')
  ]);

  final phoneNumberValidator = MultiValidator([
    RequiredValidator(errorText: 'Phone number is required'),
    MinLengthValidator(10, errorText: 'Phone number must be 10 digits long'),
    MaxLengthValidator(10, errorText: 'Phone number must be 10 digits long')
  ]);

  final surnameValidator = MultiValidator([
    RequiredValidator(errorText: 'Surname is required'),
    MinLengthValidator(3,
        errorText: 'Surname must be at least 3 characters long')
  ]);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundPrimary,
              body: Stack(children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: pageHorizontalMargin,
                      vertical: pageVerticalMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      largeSpace,
                      Text(
                        'Create an account',
                        style: headerTextFont,
                      ),
                      Flexible(
                        child: ListView(
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  mediumSpace,
                                  customInputField(
                                      fieldTitle: 'Name',
                                      controller: nameController,
                                      validator: nameValidator),
                                  customInputField(
                                      fieldTitle: 'Email address',
                                      controller: emailController,
                                      validator: emailValidator,
                                      inputType: TextInputType.emailAddress),
                                  customInputField(
                                      fieldTitle: 'Surname',
                                      controller: surnameController,
                                      validator: surnameValidator,
                                      inputType: TextInputType.streetAddress),
                                  customInputField(
                                      fieldTitle: 'Phone Number',
                                      controller: phoneNumberController,
                                      validator: phoneNumberValidator,
                                      inputType: TextInputType.phone),
                                  customInputField(
                                      fieldTitle: 'Password',
                                      controller: passwordController,
                                      validator: passwordValidator,
                                      inputType: TextInputType.visiblePassword),
                                  customInputField(
                                      fieldTitle: 'Confirm password',
                                      validator: (val) => MatchValidator(
                                              errorText:
                                                  'passwords do not match')
                                          .validateMatch(
                                              val, passwordController.text),
                                      controller: confirmPasswordController,
                                      inputType: TextInputType.visiblePassword),
                                  customButton('Create account', () {
                                    if (_formKey.currentState.validate()) {
                                      model.signUp(
                                          email: emailController.text,
                                          surname: surnameController.text,
                                          name: nameController.text,
                                          password: passwordController.text,
                                          phoneNo: phoneNumberController.text);
                                    }
                                  })
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                loadingIndicator(model.isBusy, 'Creating account..')
              ]),
            ),
        viewModelBuilder: () => SignUpViewModel());
  }
}
