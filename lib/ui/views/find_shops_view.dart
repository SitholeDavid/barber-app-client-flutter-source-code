import 'package:barber_app_client/core/models/store.dart';
import 'package:barber_app_client/core/viewmodels/find_shops_viewmodel.dart';
import 'package:barber_app_client/ui/constants/ui_helpers.dart';
import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:barber_app_client/ui/widgets/heading_tile.dart';
import 'package:barber_app_client/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class FindShopsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FindShopsViewModel>.reactive(
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
                        HeaderTileWidget(
                          heading: 'Find store',
                        ),
                        largeSpace,
                        TextFormField(
                          style: mediumTextFont.copyWith(color: Colors.black87),
                          onChanged: (val) {
                            model.searchForStore(val);
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
                        Flexible(
                            child: ListView.builder(
                                itemCount: model.isBusy
                                    ? 0
                                    : model.filteredStores.length,
                                itemBuilder: (context, index) {
                                  return storeTile(
                                      model.filteredStores[index],
                                      () => model.navigateToStoreDetailsView(
                                          model.filteredStores[index].storeID));
                                })),
                      ])),
              loadingIndicator(model.isBusy, 'Loading stores..')
            ])),
        onModelReady: (model) async => await model.initialise(),
        viewModelBuilder: () => FindShopsViewModel());
  }
}

Widget storeTile(Store store, Function onTapCallback) {
  return GestureDetector(
    onTap: onTapCallback,
    child: Card(
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          trailing: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(10, 15)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://i.pinimg.com/236x/63/8b/1e/638b1e3d2b02dd891fc8e12fb433b83e--jay-baruchel-beautiful-men.jpg'))),
            child: SizedBox(
              height: 1,
              width: 1,
            ),
          ),
          title: Text(
            store.name,
            style: mediumTextFont.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.15,
                fontSize: 15,
                color: Colors.black87),
          ),
          subtitle: Container(
            margin: EdgeInsets.only(top: 5),
            child: Text(
              store.address,
              style: smallTextFont.copyWith(
                  color: Colors.black45,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2),
            ),
          ),
        ),
      ),
    ),
  );
}
