import 'package:barber_app_client/core/viewmodels/login_viewmodel.dart';
import 'package:barber_app_client/ui/constants/margins.dart';
import 'package:barber_app_client/ui/constants/ui_helpers.dart';
import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:barber_app_client/ui/widgets/custom_button.dart';
import 'package:barber_app_client/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundPrimary,
              body: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: pageHorizontalMargin,
                        vertical: pageVerticalMargin),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          extraLargeSpace,
                          Text(
                            model.title,
                            style: headerTextFont,
                          ),
                          mediumSpace,
                          Text(
                            model.description,
                            style: mediumTextFont.copyWith(
                                letterSpacing: 1.5, color: Colors.white70),
                          ),
                          Expanded(child: Text('')),
                          TextFormField(
                            validator: emailValidator,
                            controller: emailController,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp("[ ]"))
                            ],
                            decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: smallTextFont.copyWith(
                                    letterSpacing: 1.25, color: Colors.black45),
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                          mediumSpace,
                          TextFormField(
                            validator: passwordValidator,
                            controller: passwordController,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp("[ ]"))
                            ],
                            decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: smallTextFont.copyWith(
                                    letterSpacing: 1.25, color: Colors.black45),
                                fillColor: Colors.white,
                                filled: true,
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                          largeSpace,
                          customButton('LOGIN', () {
                            if (_formKey.currentState.validate()) {
                              model.login(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          }),
                          mediumSpace,
                          GestureDetector(
                            onTap: model.navigateToSignUp,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Don\'t have an account? Sign up',
                                style: mediumTextFont.copyWith(
                                    color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          smallSpace
                        ],
                      ),
                    ),
                  ),
                  loadingIndicator(model.isBusy, model.loadingText)
                ],
              ),
            ),
        viewModelBuilder: () => LoginViewModel());
  }
}
