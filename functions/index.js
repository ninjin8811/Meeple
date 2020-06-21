const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const algoliasearch = require('algoliasearch')
const ALGOLIA_ID = functions.config().algolia.app_id
const ALGOLIA_ADMIN_KEY = functions.config().algolia.api_key
const ALGOLIA_SEARCH_KEY = functions.config().algolia.search_key
const client = algoliasearch(ALGOLIA_ID, ALGOLIA_ADMIN_KEY)

const MALE_USER_INDEX_NAME = 'male-users'
const FEMALE_USER_INDEX_NAME = 'female-users'

exports.createMaleUser = functions.firestore
		.document('users/male/two/{userId}')
		.onCreate((snap, context) => {
			const userData = snap.data()
			userData.objectID = context.params.userId

			const index = client.initIndex(MALE_USER_INDEX_NAME)
			return index.saveObject(userData)
		})

exports.createFemaleUser = functions.firestore
		.document('users/female/two/{userId}')
		.onCreate((snap, context) => {
			const userData = snap.data()
			userData.objectID = context.params.userId

			const index = client.initIndex(FEMALE_USER_INDEX_NAME)
			return index.saveObject(userData)
		})

exports.updateMaleUser = functions.firestore
		.document('users/male/two/{userId}')
		.onUpdate((change, context) => {
			const changeData = change.after.data();
			changeData.objectID = context.params.userId

			const index = client.initIndex(MALE_USER_INDEX_NAME)
			return index.partialUpdateObject(changeData, { createIfNotExists: true })
		})

exports.updateMaleUser = functions.firestore
		.document('users/male/two/{userId}')
		.onUpdate((change, context) => {
			const changeData = change.after.data();
			changeData.objectID = context.params.userId

			const index = client.initIndex(FEMALE_USER_INDEX_NAME)
			return index.partialUpdateObject(changeData, { createIfNotExists: true })
		})
