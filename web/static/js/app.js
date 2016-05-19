// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
var ErrorList = React.createClass({
	render: function(){
		var errors = this.props.errors.map(function(error, index){
			return <li key={"error-" + index}>{error.col}: {error.msg.toString()}</li>
		})
		return (
			<ul>{errors}</ul>
		)
	}
})
var PropertiesList = React.createClass({
  render: function() {
    var propertyNodes = this.props.properties.map(function(property) {
      return (
        <li key={property.id}>{property.bathrooms}, {property.bedrooms}, {property.description}, {property.kind}, {property.lat}, {property.lon}, {property.serviced.toString()}</li>
      );
    });
    return (
      <ul>
        {propertyNodes}
      </ul>
    );
  }
});

var PropertyForm = React.createClass({
  getInitialState: function() {
    return {bathrooms: '', bedrooms: '', description: '', kind: '', lat: '', lon: '', serviced: ''};
  },
  handleBathroomsChange: function(e) {
    this.setState({bathrooms: e.target.value});
  },
  handleBedroomsChange: function(e) {
    this.setState({bedrooms: e.target.value});
  },
  handleDescriptionChange: function(e) {
    this.setState({description: e.target.value});
  },
  handleKindChange: function(e) {
    this.setState({kind: e.target.value});
  },
  handleLatChange: function(e) {
    this.setState({lat: e.target.value});
  },
  handleLonChange: function(e) {
    this.setState({lon: e.target.value});
  },
  handleServicedChange: function(e) {
    this.setState({serviced: e.target.value});
  },
  handleSubmit: function(e) {
    e.preventDefault();
    this.props.onPropertySubmit(this.state);
    //this.setState({property: this.state});
  },
  render: function() {
    return (
      <form onSubmit={this.handleSubmit}>
        <input
          type="text"
          placeholder="Bathrooms"
          value={this.state.bathrooms}
          onChange={this.handleBathroomsChange}
        />
        <input
          type="text"
          placeholder="Bedrooms"
          value={this.state.bedrooms}
          onChange={this.handleBedroomsChange}
        />
        <input
          type="text"
          placeholder="Description"
          value={this.state.description}
          onChange={this.handleDescriptionChange}
        />
        <input
          type="text"
          placeholder="Kind"
          value={this.state.kind}
          onChange={this.handleKindChange}
        />
        <input
          type="text"
          placeholder="Lat"
          value={this.state.lat}
          onChange={this.handleLatChange}
        />
        <input
          type="text"
          placeholder="Lon"
          value={this.state.lon}
          onChange={this.handleLonChange}
        />
        <input
          type="text"
          placeholder="Serviced"
          value={this.state.serviced}
          onChange={this.handleServicedChange}
        />
        <input type="submit" value="Post" />
      </form>
    );
  }
});
var PropertiesBox = React.createClass({
  getInitialState: function(){
  	return {
  		properties: [],
  		errors: []
  	}
  },
  componentDidMount: function(){
  	$.ajax({
      url: "/api/v1/properties",
      dataType: 'json',
      cache: false,
      success: function(data) {
        this.setState({properties: data.properties});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(err);
      }.bind(this)
    });
  },
  handlePropertySubmit: function(property){
  	$.ajax({
      url: "/api/v1/properties",
      dataType: 'json',
      type: 'POST',
      data: {property: property},
      success: function(data) {
      	var properties = this.state.properties.push(data.property);
        this.setState({properties: properties, errors: []});
      }.bind(this),
      error: function(xhr, status, err) {
        var error = JSON.parse(xhr.responseText)
        this.setState({errors: error.error});
      }.bind(this)
    });
  },
  render: function() {
    return (
      <div>
      	<ErrorList errors={this.state.errors} />
        <PropertiesList properties={this.state.properties} />
        <PropertyForm onPropertySubmit={this.handlePropertySubmit}/>
      </div>
    );
  }
});

ReactDOM.render(
  <PropertiesBox />,
  document.getElementById('content')
);