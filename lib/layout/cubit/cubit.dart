import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/cubit/states.dart';
import 'package:news_app/network/local/cache_helper.dart';
import '../../modules/business_screen.dart';
import '../../modules/science_screen.dart';
import '../../modules/sports_screen.dart';
import '../../network/reomte/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitialState());
  static NewsCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems =
  [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business,
      ),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports_soccer,
      ),
      label: 'Sports',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),
  ];

  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),


  ];

  List<String> Titles =
  [
    'BUSINESS NEWS',
    'SPORTS NEWS',
    'SCIENCE NEWS',
  ];


  void changeBottomNavBar(int index)
  {
    currentIndex = index;
    if(index == 1)
      getSportes();
    if(index == 2)
      getScience();
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];

  void getBusiness()
  {
    emit(NewsGetBusinessLoadingState());

    DioHelper.getData(
      url: 'v2/top-headlines',
      query:
      {
        'country':'eg',
        'category':'business',
        'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
      },
    ).then((value)
    {
      //print(value.data['articles'][0]['title']);
      business = value.data['articles'];
      print(business[0]['title']);

      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }


  List<dynamic> sportes = [];

  void getSportes() {
    {
      emit(NewsGetSportsLoadingState());

      if (sportes.length == 0) {
        DioHelper.getData(
          url: 'v2/top-headlines',
          query:
          {
            'country': 'eg',
            'category': 'sports',
            'apiKey': '65f7f556ec76449fa7dc7c0069f040ca',
          },
        ).then((value) {
          //print(value.data['articles'][0]['title']);
          sportes = value.data['articles'];
          print(sportes[0]['title']);

          emit(NewsGetSportsSuccessState());
        }).catchError((error) {
          print(error.toString());
          emit(NewsGetSportsErrorState(error.toString()));
        });
      } else {
        emit(NewsGetSportsSuccessState());
      }
    }
  }
  List<dynamic> science = [];

    void getScience()
    {
      emit(NewsGetScienceLoadingState());

      if (science.length == 0) {
        DioHelper.getData(
          url: 'v2/top-headlines',
          query:
          {
            'country': 'eg',
            'category': 'science',
            'apiKey': '65f7f556ec76449fa7dc7c0069f040ca',
          },
        ).then((value) {
          //print(value.data['articles'][0]['title']);
          science = value.data['articles'];
          print(science[0]['title']);

          emit(NewsGetScienceSuccessState());
        }).catchError((error) {
          print(error.toString());
          emit(NewsGetScienceErrorState(error.toString()));
        });
      } else {
        emit(NewsGetScienceSuccessState());
      }
    }

  List<dynamic> search = [];

  void getSearch(String value)
  {
    emit(NewsGetSearchLoadingState());

    DioHelper.getData(
      url: 'v2/everything',
      query:
      {
        'q':'$value',
        'apiKey':'65f7f556ec76449fa7dc7c0069f040ca',
      },
    ).then((value)
    {
      //print(value.data['articles'][0]['title']);
      search = value.data['articles'];
      print(search[0]['title']);

      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorState(error.toString()));
    });
  }

  bool isDark = false;
  void changeAppMode({bool? fromShared})
  {
    if (fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else
    {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }
  }

