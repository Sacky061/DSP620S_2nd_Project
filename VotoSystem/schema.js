const schema = `
# declare custom scalars for date as GQDate
scalar GQDate

# comment type
type Comment {
	votoid: ID!
	commentid: String!
	content: String
}
# voto type
type VoTo {
    id: ID!
    firstName: String
    lastName: String
    dob: GQDate
    country: String
    region: String
    constituency: String
	comments: [Comment]
}
enum VoToStatus {
	done
	pending
}
#implementations of READ in the CRUD operations
type Query {
    # Return a VoTo by id
    VoTo(id: ID!): VoTo
    # Return all voting exercises
    VoTos(limit: Int): [VoTo]
}
#implementations of CREATE, UPDATE, DELETE in the CRUD operations
type Mutation {
    # Create a VoTo
    createVoTo (id: ID!, firstName: String,lastName: String, dob: GQDate, country: String, region: String, constituency: String, status: VoToStatus): VoTo
	addComment(votoid: ID!, content: String): Comment
    # Update a VoTo
    updateVoTo (id: ID!, firstName: String,lastName: String, dob: GQDate, country: String, region: String, constituency: String, status: VoToStatus): VoTo
	
    # Delete a VoTo
    deleteVoTo(id: ID!, status: VoToStatus): VoTo
	
}
`;

module.exports.Schema = schema;