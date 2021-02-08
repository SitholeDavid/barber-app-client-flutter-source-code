import 'package:barber_app_client/core/models/employee.dart';
import 'package:barber_app_client/core/viewmodels/shop_details_viewmodel.dart';
import 'package:barber_app_client/ui/constants/routes.dart';
import 'package:barber_app_client/ui/constants/ui_helpers.dart';
import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:barber_app_client/ui/widgets/custom_button.dart';
import 'package:barber_app_client/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';

class ShopDetailsView extends StatelessWidget {
  final String storeID;
  ShopDetailsView({this.storeID});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShopDetailsViewModel>.reactive(
        onModelReady: (model) async => await model.initialise(storeID),
        builder: (context, model, child) => Scaffold(
            backgroundColor: backgroundSecondary,
            body: Stack(children: [
              Container(
                height: 300,
                width: double.infinity,
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: backgroundPrimary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(30, 20),
                        bottomRight: Radius.elliptical(30, 20))),
              ),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        largeSpace,
                        Flexible(
                            child: Text(
                          'Store employees',
                          style: headerTextFont,
                        )),
                        largeSpace,
                        TextFormField(
                          style: mediumTextFont.copyWith(color: Colors.black87),
                          onChanged: (val) {
                            //model.searchForStore(val);
                            return;
                          },
                          decoration: InputDecoration(
                              hintStyle: mediumTextFont.copyWith(
                                  color: Colors.black54, letterSpacing: 1.5),
                              hintText: 'Search',
                              suffixIcon: Icon(Icons.search),
                              fillColor: Colors.white.withOpacity(0.95),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9))),
                        ),
                        mediumSpace,
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.isBusy
                                ? 0
                                : model.filteredEmployees.length,
                            itemBuilder: (context, index) {
                              var employee = model.filteredEmployees[index];
                              var validGradient;

                              if (employee.workingToday) {
                                if (employee.noWaiting < 3)
                                  validGradient = fewClientsGradient;
                                else if (employee.noWaiting < 5)
                                  validGradient = averageClientsGradient;
                                else
                                  validGradient = highClientsGradient;
                              } else
                                validGradient = notWorkingGradient;

                              return Card(
                                elevation: 1.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13)),
                                  child: ExpansionTile(
                                    trailing: SizedBox(
                                      height: 1,
                                      width: 1,
                                    ),
                                    leading: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(10, 15)),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(employee
                                                      .displayPictureUrl.isEmpty
                                                  ? 'https://i.pinimg.com/236x/63/8b/1e/638b1e3d2b02dd891fc8e12fb433b83e--jay-baruchel-beautiful-men.jpg'
                                                  : employee
                                                      .displayPictureUrl))),
                                      child: SizedBox(
                                        height: 1,
                                        width: 1,
                                      ),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Text(
                                          '${employee.name} ${employee.surname}',
                                          style: mediumTextFont.copyWith(
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.15,
                                              fontSize: 15,
                                              color: Colors.black87)),
                                    ),
                                    subtitle: Text(
                                      employee.role.toUpperCase(),
                                      style: smallTextFont.copyWith(
                                          color: Colors.black45,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 2),
                                    ),
                                    children: [
                                      mediumSpace,
                                      Container(
                                          width: 260,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              gradient: validGradient,
                                              borderRadius:
                                                  BorderRadius.circular(1000)),
                                          child: Text(
                                            (employee.workingToday
                                                    ? '${employee.noWaiting} people in line'
                                                    : '${employee.name} is unavailable')
                                                .toUpperCase(),
                                            style: smallTextFont.copyWith(
                                                color: Colors.white,
                                                fontSize: 10,
                                                letterSpacing: 1.25),
                                          )),
                                      customButtonDark(
                                          'Check availability',
                                          () => model
                                              .navigateToBookingView(index)),
                                      smallSpace
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ])),
              loadingIndicator(model.isBusy, 'Loading stores details..')
            ])),
        viewModelBuilder: () => ShopDetailsViewModel());
  }
}
