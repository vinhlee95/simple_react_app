import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>New change to the app</h1>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
        <p>The API key is {process.env.REACT_APP_API_KEY}</p>
      </header>
    </div>
  );
}

export default App;
