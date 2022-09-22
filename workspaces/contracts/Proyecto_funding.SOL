
// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Proyecto_funding{


    struct Proyecto {
        string  id;
        string  name;
        string  descripcion;
        address payable  walletAutor;
        EnumEstado state;
        uint  funds; //Almacena todos los aportes
        uint  fundRaisingGoal; //Cuanto se espera ganar con la ronda de fundraising
    }




    Proyecto [] public  proyectos; // Se crea un array proyectos de tipo STRUCT Proyecto

    enum EnumEstado {open, closed }
    



    modifier requiereFundRaisin(uint x){
        require(x>0,"debe ingresar un objetivo de recaudacion mayor a cero");
        _;

    }


    function createProject(string memory _id, string memory _name, string memory _descripcion, uint _fundRaisingGoal) public requiereFundRaisin(_fundRaisingGoal) {
        
         
         Proyecto memory proyecto;
         proyecto= Proyecto(_id, _name, _descripcion, payable(msg.sender), EnumEstado.open, 0, _fundRaisingGoal);

         proyectos.push(proyecto);

    }





    modifier requireChangeName(uint indiceProyectos) {
        require( msg.sender == proyectos[indiceProyectos].walletAutor, "no puede modificar el proyecto"); 
        _;
    }

    modifier  requireFundProyect (uint indiceProyectos) {
        require(msg.sender != proyectos[indiceProyectos].walletAutor, "un autor del proyecto no puede autofinanciarse");
        _;

    }
    
    event eveContribuidor(address walletInversor, uint valueContribucion);
    event eveStateChanche(string id_p_, EnumEstado state_p_);


    struct StructContibucion {
        address walletInversor;
        uint montoInvertido;
    }


    StructContibucion contribucion;
    StructContibucion [] arraycontribucion;

    mapping(string => StructContibucion[]) public contibuciones;







    function fundProject (uint indiceProyectos) public payable requireFundProyect(indiceProyectos) { //funcion que registra el aporte
        

        Proyecto memory proyecto;   // se crea la variable proyecto de tipo struct, que solo se almacena en memoria
        proyecto=proyectos[indiceProyectos]; //se asignan los valores a la variable de tipo Struct a partir del ARRAY que se almacena en Storage

        require(proyecto.state != EnumEstado.closed, "la financiacion esta cerrada");
        require(msg.value > 0 , "no se pude aportar cero fondos");     
        
        proyecto.walletAutor.transfer(msg.value);
        proyecto.funds+=msg.value; // se modifica un valor de la variable STRUCT

        proyectos[indiceProyectos]=proyecto; // Se guarda el Struct modificado dentro del array para almacenar la modificacion en Storage

        emit eveContribuidor(msg.sender, msg.value); 
        
        contribucion=StructContibucion(msg.sender,msg.value);
        arraycontribucion.push(contribucion);
        contibuciones[proyecto.id]=arraycontribucion;

    }

    function changeProjectState(EnumEstado  newStage, uint indiceProyectos) public requireChangeName(indiceProyectos)
    
    {
        Proyecto memory proyecto;
        proyecto=proyectos[indiceProyectos];
        //require(state != newStage, "ngfn");
        proyecto.state=newStage;
        emit eveStateChanche(proyecto.id, proyecto.state);

    }
}
