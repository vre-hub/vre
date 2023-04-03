import logo from './data-science.png';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Welcome to the CERN VRE!
        </p>
        <a
          className="App-link"
          href="https://nb-vre.cern.ch/"
          target="_blank"
          rel="noopener noreferrer"
        >
          Start using the VRE
        </a>
      </header>
      <footer>
      <a href="https://www.flaticon.com/free-icons/data-science" title="data science icons">Data science icons created by Paul J. - Flaticon</a>
      </footer>
    </div>
  );
}

export default App;
