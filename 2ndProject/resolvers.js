const { GraphQLScalarType } = require("graphql");

function convertDate(inputFormat) {
  function pad(s) {
    return s < 10 ? "0" + s : s;
  }
  var d = new Date(inputFormat);
  return [pad(d.getDate()), pad(d.getMonth()), d.getFullYear()].join("/");
}

// Define Date scalar type.

const GQDate = new GraphQLScalarType({
  name: "GQDate",
  description: "Date type",
  parseValue(value) {
    // value comes from the client
    return value; // sent to resolvers
  },
  serialize(value) {
    // value comes from resolvers
    return value; // sent to the client
  },
  parseLiteral(ast) {
    // value comes from the client
    return new Date(ast.value); // sent to resolvers
  }
});

// data store with default data
const VoTo = [
  {
    id: 1,
    firstName: "Peter",
    lastName: "Pan",
    dob: new Date("2002-08-31"),
    country: "Namibia",
    region: "Khomas",
    constituency: "katutura",
	status: "pending",
	comments: "Your vote count"
  },
  {
    id: 2,
    firstName: "Shapumba",
    lastName: "forever",
    dob: new Date("1971-05-24"),
    country: "Namibia",
    region: "Khomas",
    constituency: "Jonh Pandeni",
	status: "done",
	comments: "Your vote count"
  },
  {
    id: 3,
    firstName: "P'mumu",
    lastName: "Onetime",
    dob: new Date("1990-07-02"),
    country: "Namibia",
    region: "Khomas",
    constituency: "khomasdal",
	status: "done",
	comments: "Your vote count"
  },
  {
    id: 4,
    firstName: "Jericho",
    lastName: "Hiphop",
    dob: new Date("1991-09-05"),
    country: "Namibia",
    region: "Khomas",
    constituency: "Windhoek West",
	status: "done",
	comments: "Your vote count"
  }
];

const resolvers = {
  Query: {
    VoTos: () => votos, // return all votos
    VoTo: (_, { id }) =>
      votos.find(voto => voto.id == id) // return voto by id
  },
  Mutation: {
    // create a new voto
    createVoTo: (root, args) => {
      // get next registration id
      const nextId =
        votos.reduce((id, voto) => {
          return Math.max(id, voto.id);
        }, -1) + 1;
      const newVoTo = {
        id: nextId,
        firstName: args.firstName,
        lastName: args.lastName,
        dob: args.dob,
        country: args.country,
        region: args.region,
        constituency: args.constituency,
		status: args.status,
		comments: args.comments
      };
      // add voto to collection
      voto.push(newVoTo);
      return newVoTo;
    }, // delete voto by id
    deleteVoTo: (root, args) => {
      // find index by id
      const index = votos.findIndex(
        voto => voto.id == args.id
      );
      // remove voto by index
      votos.splice(index, 1);
    }, // update voto
    updateVoTo: (root, args) => {
      // find index by id
      const index = votos.findIndex(
        voto => voto.id == args.id
      );
      votos[index].firstName = args.firstName;
      votos[index].lastName = args.lastName;
      votos[index].dob = args.dob;
      votos[index].country = args.country;
      votos[index].region = args.region;
      votos[index].constituency = args.constituency;
	  votos[index].status = args.status;
	  votos[index].comments = args.comments;
      return votos[index];
    }
  },
  GQDate
};

module.exports.Resolvers = resolvers;
