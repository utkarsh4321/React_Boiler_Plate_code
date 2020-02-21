#! /usr/bin/bash








# BOILER PLATE CODE FOR WRITING REACT APP


function ut(){



# ====================== #
   # GLOBAL VARIABLES
# ====================== #
SOURCE_DIRECTORY=src
STORE_DIRECTORY=store
REDUCER_DIRECTORY=reducers
SAGA_DIRECTORY=sagas
CONSTANTS_DIRECTORY=constants
SERVICE_DIRECTORY=services
ACTIONS_DIRECTORY=actions

# INDEX FILE
INDEX_FILE=index


# FILE ARRAYS
FILEARRAYS=($STORE_DIRECTORY $REDUCER_DIRECTORY $SAGA_DIRECTORY $SERVICE_DIRECTORY $ACTIONS_DIRECTORY)

  
 # =================== #
  #FUNCTIONS FOR WRITING
          #FILES
 # =================== #

 #FUNCTION FOR WRITING REDUCER INDEX FILE

 function writingReducerIndexFile(){
  local myReducer="
import { combineReducers } from 'redux';
export default ()=>
  combineReducers({
      /*Write your reducer here*/
  });
  
  
  
  "
echo "$myReducer";

 }
# FUNCTION FOR WRITING SAGA FILE
 
function writeSagaIndexFile(){
 local mySaga="
 import { all } from 'redux-saga/effects';
 export default function* rootSaga() {
    yield all([
       /*Write Saga here*/
    ]);
}
 
 "
echo "$mySaga";
}


# FUNCTION FOR WRITING STORE INDEX FILE

function writeStoreIndexFile(){

local myStore="
import { createStore, applyMiddleware, compose } from 'redux';
import createSagaMiddleware from 'redux-saga';

import rootReducer from '../reducers';
import rootSaga from '../sagas';

const sagaMiddleware = createSagaMiddleware();
const middleware = applyMiddleware(sagaMiddleware);

const reduxDevTools = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

const store = createStore(
    rootReducer,
    reduxDevTools(
        middleware
    )  
);

sagaMiddleware.run(rootSaga);

export default store;



"
 echo "$myStore";

}
# FUNCTION FOR WRITING APP.JS FILE

function writeAppjsFile(){
local myApp="import React, { Fragment } from 'react';
import { Route, Switch, Redirect} from 'react-router-dom';
import './App.css';


const App = () => (
        <Fragment>
                <h1>HEllo  i created with bash script or $1</h1>
                <Router />
        </Fragment>
    
);

const Router = () => {
    return (<Switch></Switch>)}

export default App;    


"
echo "$myApp"


}
# WRITING INDEX JS FILE
function writeIndexFile(){
   local myIndex="
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import { Provider } from 'react-redux';
import store from './store';
import { BrowserRouter as Router } from 'react-router-dom';


ReactDOM.render(
  <Provider store={store}>
    <Router>
      <App />
    </Router>
  </Provider>,
  document.getElementById('root')
);



   " 
   echo "$myIndex";
}


# FUNCTION FOR CREATE REACT APP
function createReactApp(){
if [[ ! -d $1/$SOURCE_DIRECTORY ]]
then    
    # npm packages installation
    if [[ $2 == 'npm' ]]
    then 
        echo "Installing Start with npm"
       npx create-react-app $1 --use-npm
    else
       echo "Installing start with yarn"
       npx create-react-app $1

    fi   
    # npx create-react-app $1 
    
    if [[ -e $1/package.json ]] 
    then
        if [[ $2 == 'npm' ]]
        then 
            cd $1
            # INSTALLING REDUX
            npm install redux --save
            # INSTALLING REACT_REDUX
             npm i react-redux --save
             # INSTALLING REDUX SAGA
            npm i redux-saga --save
            # INSTALLING REACT ROUTER
            npm i react-router-dom --save
            cd ..
        else
                # INSTALLING REDUX
                yarn --cwd $1 add redux
                # INSTALLING REDUX SAGA 
                yarn --cwd $1 add redux-saga
                # INSTALLING REACT ROUTER
                yarn --cwd $1 add react-router-dom
                # INSTALLING REACT_REDUX
                yarn --cwd $1 add react-redux
        fi
    

    else
        echo "Package.json file not exist"
    fi    
    



    
    if [[ -d $1/$SOURCE_DIRECTORY ]]
    then 
        #  CREATING DIRECTORIES
         mkdir $1/$SOURCE_DIRECTORY/{store,reducers,sagas,constants,services,actions,components,assests,modules}
         
         # CREATING FILES

         for i in "${FILEARRAYS[@]}"; do
             touch $1/$SOURCE_DIRECTORY/$i/$INDEX_FILE.js
         done  
         #  TOUCH FOR OTHER FILES
         touch $1/$SOURCE_DIRECTORY/$CONSTANTS_DIRECTORY/{actionTypes,Constants}.js
         
         # REMOVE SOME FILES
         rm $1/$SOURCE_DIRECTORY/{App.test.js, index.css, logo.svg ,serviceWorker.js}
         # ========================== #
             # WRITING ALL FILES #
         # ========================== #

            # WRITING REDUCER FILE  
          if [[ -e $1/$SOURCE_DIRECTORY/$REDUCER_DIRECTORY/$INDEX_FILE.js ]]
          then
              cat > $1/$SOURCE_DIRECTORY/$REDUCER_DIRECTORY/$INDEX_FILE.js << EOF
$(writingReducerIndexFile)
EOF
          else
              echo "REducer index file does'nt exist"
          fi
        # WRITING SAGA INDEX FILE
         if [[ -e $1/$SOURCE_DIRECTORY/$SAGA_DIRECTORY/$INDEX_FILE.js ]]
         then 
            cat > $1/$SOURCE_DIRECTORY/$SAGA_DIRECTORY/$INDEX_FILE.js << EOF
$(writeSagaIndexFile)
EOF
         else 
             echo "Saga FILE doesn't exist"
         fi
         
         # WRITING INDEX.JS FILE
     if [[ -e $1/$SOURCE_DIRECTORY/$INDEX_FILE.js ]]
         then 
            cat > $1/$SOURCE_DIRECTORY/$INDEX_FILE.js << EOF
$(writeIndexFile)
EOF
         else 
             echo "INDEX FILE doesn't exist"
         fi
     # WRITING APP.JS FILE  
        if [[ -e $1/$SOURCE_DIRECTORY/App.js ]]
         then
            cat > $1/$SOURCE_DIRECTORY/App.js << EOF
$(writeAppjsFile $2)
EOF
         else 
             echo "App js doest not exist"
         fi
              #  WRITING STORE INDEX FILE
             if [[ -e $1/$SOURCE_DIRECTORY/$STORE_DIRECTORY/$INDEX_FILE.js ]]
         then 
            cat > $1/$SOURCE_DIRECTORY/$STORE_DIRECTORY/$INDEX_FILE.js << EOF
$(writeStoreIndexFile)
EOF
          echo "Setup completed successfully"
          echo "Starting server..."
          if [[ $2 == 'npm' ]]
          then
             cd $1
             npm start
          else
              yarn --cwd $1 start
          fi
         else 
             echo "Store index js file not exist"
         fi

         # END OF MAIN IF CONDITION
    else 
        echo "file doest not exist"
    fi   
else 
    echo "src file exists"
fi    
}




read -p "DO you want to install react [y/n]: " ans
# echo "tera ghata $ans"
# NOW SETTING tHE CONDITION
if [[ -n $ans ]]
then
    if [[ $ans == 'y' ]]
    then
        read -p "please your app name: " appName
        read -p "please select your package manager [npm/yarn]: " packageManager
        read -p "Do you also want to install redux [y/n]: " reduxans
        if [[ $reduxans == 'y' ]]
        then
            echo "Wait... proccess started soon"
            createReactApp $appName $packageManager
        else
            echo "call function only for creat react app"
            if [[ $packageManager == 'npm' ]]
            then
                npx create-react-app $appName --use-npm
                cd $appName
                npm start
            else
                npx create-react-app $appName
                yarn --cwd $appName start
            fi    
        fi
    elif [[ $ans == 'n' ]]
    then
       echo "okay you have a great day" 
    fi     
else
   echo "Please select any options"
fi    

}

# ut    This will call the function ut and start the whole script



