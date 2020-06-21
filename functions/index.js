const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

const algoliasearch = require('algoliasearch')
const ALGOLIA_ID = functions.config().algolia.app_id
const ALGOLIA_ADMIN_KEY = functions.config().algolia.api_key
const ALGOLIA_SEARCH_KEY = functions.config().algolia.search_key
const client = algoliasearch(ALGOLIA_ID, ALGOLIA_ADMIN_KEY)

const MALE_USER_INDEX_NAME = 'male-users'
// const FEMALE_USER_INDEX_NAME = 'female-users'

exports.createMaleUser = functions.firestore
		.document('users/male/two/{userId}')
		.onCreate((snap, context) => {
			const userData = snap.data()
			userData.objectID = context.params.userId

			console.log(222)

			const index = client.initIndex(MALE_USER_INDEX_NAME)
			return index.saveObject(userData)
		})

// snapのデータ形式がよくわからんくてエラー出てる
// exports.indexMaleUser = functions.firestore
// 		.document('users/male/two/{userId}')
// 		.onUpdate((snap, context) => {
// 			const userData = snap.data()
// 			userData.objectID = context.params.userId

// 			const index = client.initIndex(MALE_USER_INDEX_NAME)
// 			return index.partialUpdateObject(userData, { createIfNotExists: true })
// 		})

// const ALGOLIA_INDEX_NAME = 'test1'
// exports.indexCity = functions.firestore
// 		.document('city/{cityId}')
// 		.onCreate((snap, context) => {
// 			const data = snap.data()
// 			data.objectID = context.params.cityId

// 			const index = client.initIndex(ALGOLIA_INDEX_NAME);
// 			return index.saveObject(data)
// 		})
