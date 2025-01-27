import 'dart:async';

import 'package:proyectoprograufro/modelo/ficha.dart';
import 'package:proyectoprograufro/code/api.dart';
import 'package:proyectoprograufro/views/details/details_page.dart';
import 'package:proyectoprograufro/views//routes.dart';
import 'package:flutter/material.dart';
import 'package:proyectoprograufro/code/conexion.dart';

class FichaList extends StatefulWidget {
  @override
  _FichaListState createState() => new _FichaListState();
}

enum VistaUsuario{ visible,novisible}

class _FichaListState extends State<FichaList> {
  List<Ficha> _fichas = [];

  CodaAPi _api;
  NetworkImage _profileImage;
  VistaUsuario _vistaUsuario = VistaUsuario.visible;


  @override
  void initState() {
    super.initState();
    _loadFromFirebase();
  }

  _loadFromFirebase() async {
    final api = await CodaAPi.signInWithGoogle();
    final fichas = await api.getUsuarioFichas();
   // final usuarioFicha = await api.getUsuarioFichas();
    //separa fichas
    // var filtroUsuarios = fichas.where((Ficha fichaa){
    //   if(_vistaUsuario == VistaUsuario.visible){
    //     return fichaa.usuariosId[0] ==null || fichaa.usuariosId == fichas.;
    //   }else{
    //     return fichaa.usuariosId[0] == _api.firebaseUser.uid;
    //   }
    // }).toList();
    setState(() {
      _api = api;
      _fichas = fichas;
      _profileImage = new NetworkImage(api.firebaseUser.photoUrl);
    });
  }

  _reloadfichas() async {
    if (_api != null) {
      final fichas = await _api.getTodasFichas();
      setState(() {
        _fichas = fichas;
      });
    }
  }

  Widget _buildCatItem(BuildContext context, int index) {
    Ficha ficha = _fichas[index];
   // List<Ficha> pacientess = [];
    //_lateralMenu();
    
    if(_api.firebaseUser.uid == ficha.usuariosId[0]){
        //pacientess.add(ficha);
    };
    //print(pacientess);
    //print(_api.firebaseUser.uid);
    return Container(

      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: new Column(

          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //Dismissible _vistaUsuario[0] == VistaUsuario.visible;
            //new Drawer();
            new ListTile(
              onTap: () => _navigateToCatDetails(ficha, index),
              leading: new Hero(
                tag: index,
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(ficha.avatarUrl),
                ),
              ),
              title: new Text(
                ficha.nombre,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              subtitle: new Text(ficha.direccion),
              isThreeLine: true, // Less Cramped Tile
              dense: false, // Less Cramped Tile
            ),
          ],
        ),
      ),

    );
  }

  _navigateToCatDetails(Ficha ficha, Object avatarTag) {
    Navigator.of(context).push(
      new FadePageRoute(
        builder: (c) {
          return new FichaDetailsPage(ficha, avatarTag: avatarTag);
        },
        settings: new RouteSettings(),
      ),
    );
  }

  Widget _getAppTitleWidget() {
    return new Text(
      'Paciente',
      style: new TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
      ),
    );
  }


  Widget _buildBody() {
    return new Container(
      margin: const EdgeInsets.fromLTRB(
        8.0,  // A left margin of 8.0
        56.0, // A top margin of 56.0
        8.0,  // A right margin of 8.0
        0.0   // A bottom margin of 0.0
      ),
      child: new Column(
        // A column widget can have several
        // widgets that are placed in a top down fashion
        children: <Widget>[
          _getAppTitleWidget(),

          _getListViewWidget(),
        ],
      ),
    );
  }

  Future<Null> refresh() {
    _reloadfichas();
    return new Future<Null>.value();
  }

  Widget _getListViewWidget() {
    return new Flexible(
      child: new RefreshIndicator(
        onRefresh: refresh,
        child: new ListView.builder(
          //physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _fichas.length,
          itemBuilder: _buildCatItem
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.blue,
      body: _buildBody(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Fichas');
        },
        tooltip: _api != null ? 'Signed-in: ' + _api.firebaseUser.displayName : 'Not Signed-in',
        backgroundColor: Colors.blue,
        child: new CircleAvatar(
          backgroundImage: _profileImage,
          radius: 50.0,
        ),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new DrawerHeader(
              child: new Container(
                child:new Column(
                  children: <Widget>[
                    new Text('CODA ufrooo'),
                    //new Image(image: _profileImage)
                  ],
                ),
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: (){
                Navigator.pushNamed(context, '/Perfil');
              },
            ),
            new ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Fichas'),
              onTap:(){
                Navigator.pushNamed(context, '/Fichas');
              },
            ),
            new ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ajustes'),
              onTap:(){
                Navigator.pushNamed(context, '/Ajustes');
              },
            ),
            new ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Desconectarse'),
              onTap:(){
                validacion_gf().singOut();
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),

      ),
    );
  }
}
